class Update < ActiveRecord::Base
  include RunLinkable

  before_save :associate_job
  before_save :associate_rig
  after_save :link_to_run
  after_save :publish
  after_save :add_to_recent_updates

  belongs_to :job
  belongs_to :run
  belongs_to :client
  belongs_to :rig
  belongs_to :well

  validates :team_viewer_id, presence: true
  validates :team_viewer_password, presence: true
  validates :job_number, format: { with: /\A[a-zA-Z]{2}-[0-9]{6}\z/ }
  validates :pump_on_time, numericality: {less_than: 2147483647},
            allow_nil: true
  validates :pump_off_time, numericality: {less_than: 2147483647},
            allow_nil: true
  validates :pump_total_time, numericality: {less_than: 2147483647},
            allow_nil: true

  scope :active, -> {where("updated_at > ?", 1.day.ago).order(updated_at: :desc)}
  scope :recent, -> {where("updated_at > ?", 1.week.ago).order(updated_at: :desc)}

  def self.last_update_for_job job_number
    job = Job.fuzzy_find(job_number)
    job.last_update_for_type self.to_s
  end

  def self.children
    Update.descendants - [ReceiverUpdate]
  end

  def publish
    raise 'Not Implemented Error'
  end

  def newer?
    return false if self.time.blank?

    job = self.job || Job.fuzzy_find(self.job_number)
    last_job = job.last_update_for_type self.type if job.present?

    last_job.present? ? (self.time > last_job.time) : true
  end

  def self.last_updates(options={})
    caches = Job.all.pluck(:cache)

    updates = {}
    Update.children.map(&:to_s).each do |type|
      updates[type] = caches.map { |obj| obj["recent_updates"][type].try(:last) }.compact.uniq
    end

    if options[:array] then updates.values.flatten else updates end
  end

  def self.still_notifiable
    updates = Notification.active.pluck(:notifiable_id).compact.uniq
  end

  def self.destroy_old
    updates = Update.where("created_at < ?", 2.days.ago)
    last_updates = Update.last_updates(array: true)
    last_updates |= Update.still_notifiable
    updates.where.not(id: last_updates).delete_all
  end

  def last_hour?
    self.time > 1.hour.ago
  end

  private

    def associate_job
      return nil unless self.job_number.present?
      self.job = Job.fuzzy_find self.job_number
    end

    def associate_rig
      return nil unless self.rig_name.present?
      self.rig = Rig.fuzzy_find self.rig_name
    end

    def add_to_recent_updates
      return nil unless self.job.present?
      self.job.add_to_recent_updates self
      true
    end

    def cache_pump_time
     tool = Tool.find_by_uid self.uid
     tool.add_pump_time(pump_total_time) if tool.present?
    end
end
