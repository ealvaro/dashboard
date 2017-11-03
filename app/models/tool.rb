require 'csv'
require 'json'

class Tool < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :tool_type, touch: true
  has_many :jobs, through: :events
  has_many :events, dependent: :destroy
  has_many :run_records, dependent: :destroy
  has_many :runs, ->{uniq}, through: :run_records
  has_and_belongs_to_many :histograms
  validates :tool_type, presence: true, allow_nil: false
  validates :uid, uniqueness: true, presence: true, allow_nil: false, length: {minimum: 8}, if: :serialized

  validate do
    if self.uid.present? && self.uid.match(/[^a-zA-Z0-9]/)
      errors.add(:uid, "must be only a-zA-Z0-9")
    end
  end

  after_touch :update_cache_json

  before_validation on: :create do
    self.uid ||= generate_uid
  end

  scope :billable, -> {joins(:run_records).select("DISTINCT ON (tools.id) tools.*")}

  def self.search keywords
    if keywords.present?
      where("uid @@ :k OR
        cache ->> 'primary_asset_number' @@ :k OR
        cache ->> 'board_serial_number' @@ :k OR
        cache ->> 'board_firmware_version' @@ :k OR
        cache ->> 'hardware_version' @@ :k OR
        cache ->> 'job_number' @@ :k",
        k: keywords)
    end
  end

  def self.for_uid(uid)
    find_by!(uid: uid)
  end

  def self.fuzzy_find_or_initialize_by(serial_number, tool_type)
    tool = Tool.find_by(serial_number: serial_number)
    return tool if tool
    Tool.new(serial_number:serial_number, tool_type: tool_type)
  end

  def valid_uid?(uid)
    ["0000", "8000", "ffff"].exclude? uid[-4..-1]
  end

  def generate_uid
    size = 8
    uid = SecureRandom.hex(size)
    while !valid_uid?(uid)
      uid = SecureRandom.hex(size)
    end
    uid
  end

  def alert!(hash)
    if receiver?
      if @job = Job.fuzzy_find(hash[:job])
        Subscription.where("job_id = ? and interests like '%ThresholdNoti%' and threshold_setting_id is not null", @job.id).each do |sub|
          violations = sub.threshold_setting.violations(hash)
          if violations.length > 0
            subject = "Receiver #{uid_display} has violated at least one of it's threshold settings. #{violations}"
            ThresholdNotification.create! subject: subject,
                                          assignee: sub.user,
                                          severity: 0,
                                          alertable: self
          end
        end
      end
    end
  end

  def cache
    read_attribute( :cache ) || {}
  end

  def receiver?
    tool_type.number == 4
  end

  def status
    events.statuses.last ? events.statuses.last.event_type : "Status - In Service"
  end

  def update_cache_json
    last_event = events.last
    return true if cache["time"] && last_event && cache["time"] > last_event.time
    tmp = events.last.nil? ? {} : cache.merge( events.last.attributes.reject{|k,v| k == "id" || k == "tool_id" || v.blank?}.to_hash )
    tmp.merge!( event_assets: last_event.event_assets ) unless last_event.blank? || last_event.event_assets.blank?
    tmp["configs"] = last_event.configs unless last_event.blank? || last_event.configs.select{|k,v| !v.blank?}.length == 0
    tmp.merge!( tool_type_name: tool_type.name ) if tool_type
    tmp.merge!( status: status )
    tmp.merge!( job_number: last_event.job.name) if last_event && last_event.job
    tmp.merge!( run_number: last_event.run.number) if last_event && last_event.run
    tmp.merge!( client_name: last_event.client.name) if last_event && last_event.client
    tmp.merge!( well_name: last_event.well.name) if last_event && last_event.well
    tmp.merge!( rig_name: last_event.rig.name) if last_event && last_event.rig
    if last_event && last_event.team_viewer_id && last_event.team_viewer_password
      tmp.merge!( team_viewer_id: last_event.team_viewer_id, team_viewer_password: last_event.team_viewer_password)
    end
    to_merge = { "total_service_time" => total_service_time, "last_pump_total" => last_pump_total }
    update_attributes cache: tmp.merge(to_merge)
  end

  def last_event
    populate_cached_events unless @ran_populate
    @last_event
  end

  def first_event
    populate_cached_events unless @ran_populate
    @first_event
  end

  def last_config
    populate_cached_events unless @ran_populate
    @first_event || Naught.build.new
  end

  def board_serial_number
    last_config.board_serial_number
  end

  def primary_asset_number
    last_config.primary_asset_number
  end

  def chassis_serial_number
    last_config.chassis_serial_number
  end

  def uid_display
    tmp = ""
    for i in 0..uid.length - 1
      if i % 2 == 0
        tmp += uid[i...i+2]
        tmp += ":" unless i + 2 >= uid.length
      end
    end
    tmp
  end

  def merge!(sub_tool)
    sub_tool.events.each do |sub_event|
      sub_event.update_attributes! tool_id: id
    end
    self.update_attributes created_at: sub_tool.created_at unless created_at < sub_tool.created_at
    sub_tool.reload.destroy!
  end

  def total_service_time
    cache["total_service_time"] || 0
  end

  def last_pump_total
    cache["last_pump_total"] || 0
  end

  def add_pump_time current_pump_total
    if total_service_time == 0 || (last_pump_total > current_pump_total)
      time = current_pump_total
    else
      time = current_pump_total - last_pump_total
    end

    merge_pump_time current_pump_total, time
  end

  private

    def serialized
      !non_serialized.include?(self.try(:tool_type).try(:name))
    end

    def non_serialized
      ["Pigtail", "Snubber", "Accel", "Mag", "Temp"]
    end

    def populate_cached_events
      @ran_populate = true
      @last_event = events.order( 'time ASC' ).limit( 1 ).first
      @first_event = events.order( 'time DESC' ).limit( 1 ).first
    end

    def merge_pump_time current_pump_total, time
      to_merge = { "total_service_time" => total_service_time + time,
                   "last_pump_total" => current_pump_total }
      self.cache = cache.merge(to_merge)
      save
  end
end
