require 'securerandom'

class Survey < ActiveRecord::Base
  include Authority::Abilities
  # include PgSearch
  #
  # multisearchable :against => [:job, :job_id, :key, :measured_depth_in_feet, :gx, :gy, :gz, :g_total, :hx, :hy, :hz, :h_total, :inclination, :azimuth, :dip_angle, :north, :east, :tvd, :horizontal_section, :dog_leg_severity, :start_depth]

  belongs_to :survey_import_run
  belongs_to :run
  belongs_to :user
  belongs_to :side_track
  belongs_to :accepted_by, class_name: "User"
  belongs_to :declined_by, class_name: "User"

  has_one :job, through: :run

  has_many :alerts, as: :alertable

  scope :visible, -> { where("hidden != true") }
  scope :max_measured_depth, ->(run_id) { where("run_id = ?", run_id).order("measured_depth_in_feet DESC").limit(1) }
  scope :latest_by_job_id, ->(job_id) { where("jobs.id = ?", job_id).includes(:job).references(:job).order("surveys.created_at DESC").limit(1) }

  validates :run_id, presence: true
  validates :measured_depth, presence: true
  validates :key, presence: true

  attr_accessor :measured_depth
  attr_accessor :selected_depth_units
  attr_accessor :magnetic_units
  attr_accessor :accept

  before_validation do
    if [gx, gy, gz].all? {|e| e.present? }
      self.g_total ||= Math.sqrt(gx**2 + gy**2 + gz**2)
    end
    if [hx, hy, hz].all? {|e| e.present? }
      self.h_total ||= Math.sqrt(hx**2 + hy**2 + hz**2)
    end
    true
  end

  before_validation do
    case selected_depth_units
    when "meters"
      self.measured_depth_in_feet = (measured_depth.to_f * (3280.84 / 1000)).round(2)
    else
      self.measured_depth_in_feet = measured_depth
    end
    self.measured_depth = measured_depth_in_feet
    self.selected_depth_units = "feet"
    true
  end

  before_validation on: :create do
    size = 8
    self.key ||= SecureRandom.hex(size)
  end

  after_create :cancel_alerts

  def self.search jobs
    ids = []
    if jobs then jobs.each { |j| ids << j.survey_ids } end
    where(id: ids.flatten.uniq)
  end

  def self.import_for_run(run:, side_track:, data:, user:, import_run:)
    measured_depth = data[:md]

    new = Survey.new
    new.run = run
    new.user = user
    new.side_track = side_track
    new.from_import_hash data
    new.survey_import_run = import_run

    if found = Survey.find_by(measured_depth_in_feet: measured_depth, run: run, side_track_id: (side_track ? side_track.id : nil))
      new.key = found.key
      new.version_number += found.versions.last.version_number
    else
      new.version_number = 1
    end
    new.save! unless Survey.business_exists?(new)
    new
  end

  def self.business_exists?(survey)
    Survey.where(
      run_id: survey.run_id,
      side_track_id: survey.side_track_id,
      measured_depth_in_feet: survey.measured_depth_in_feet,
      gx: survey.gx,
      gy: survey.gy,
      gz: survey.gz,
      hx: survey.hx,
      hy: survey.hy,
      hz: survey.hz,
      azimuth: survey.azimuth.try(:to_s),
      inclination: survey.inclination.try(:to_s),
      dip_angle: survey.dip_angle.try(:to_s),
      north: survey.north,
      east: survey.east,
      tvd: survey.tvd,
      horizontal_section: survey.horizontal_section,
      dog_leg_severity: survey.dog_leg_severity,
      start_depth: survey.start_depth,
      accepted_by_id: survey.accepted_by_id,
      declined_by_id: survey.declined_by_id
    ).exists?
  end

  def alert!
    if !accepted? || !declined?
      Subscription.where("interests like '%RequestSurveyApproval%' and (run_id = #{run_id} or job_id = #{job_id})").uniq{|i| i.user_id}.each do |sub|
        RequestSurveyApproval.create! subject: approval_title,
                                    assignee: sub.user,
                                    severity: 0,
                                    alertable: self

      end
    elsif corrected?
      Subscription.where("interests like '%CorrectedNotification%' and (run_id = #{run_id} or job_id = #{job_id})").uniq{|i| i.user_id}.each do |sub|
        CorrectedNotification.create! subject: notification_title,
                                  assignee: sub.user,
                                  severity: 0,
                                  alertable: self
      end
    else
      Subscription.where("interests like '%RequestCorrection%' and (run_id = #{run_id} or job_id = #{job_id})").uniq{|i| i.user_id}.each do |sub|
        RequestCorrection.create! subject: notification_title,
                                  assignee: sub.user,
                                  severity: 0,
                                  alertable: self
      end
    end
  end


  def corrected?
    versions.count > 1
  end

  def accepted?
    Survey.where("key = ? AND accepted_by_id IS NOT NULL", self.key).exists?
  end

  def declined?
    Survey.where("key = ? AND declined_by_id IS NOT NULL", self.key).exists?
  end

  def job_id
    job.try(:id)
  end

  def versions
    Survey.where(key: self.key).order("version_number asc")
  end

  def change_type
    case version_number
    when 1
      "created"
    else
      "edited"
    end
  end

  def from_import_hash(hash)
    self.measured_depth_in_feet = hash[:md]
    self.inclination = hash[:inc]
    self.azimuth = hash[:azi]
    self.dip_angle = hash[:dipa]
    hash.slice( :gx, :gy, :gz, :hx, :hy, :hz).each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def measured_depth
    @measured_depth || self.measured_depth_in_feet
  end

  def selected_depth_units
    @selected_depth_units || "feet"
  end

  def side_track_number
    side_track.try(:number)
  end

  def to_param
    self.key
  end

  private
    def notification_title
      base = corrected? ? "A survey is ready to be corrected" : "A survey has been corrected"
      job_number = job.try(:name)
      run_number = run.try(:number)
      well_name = run.try(:well).try(:name)
      if well_name || job_number
        base += " for"
        base += " WELL: #{well_name}" if well_name
        base += " JOB: #{job_number}" if job_number
        base += " RUN: #{run_number}" if run_number
        base += "."
      end
      base
    end

    def approval_title
      job_number = job.try(:name)
      subject = "A survey is ready for your approval"
      if job_number
        subject += " for #{job_number}."
      end
      subject
    end

    def cancel_alerts
      Survey.where(key: key).select(&:corrected?).flat_map{|s| s.alerts.select{|a| a.is_a?(RequestCorrection) && a.pending?}}.map(&:cancel!)
    end

end
