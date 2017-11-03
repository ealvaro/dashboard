class Job < ActiveRecord::Base
  include Authority::Abilities
  include HasRemoteOpsUpdates
  include PgSearch

  belongs_to :client
  has_many :updates
  has_many :runs, dependent: :destroy
  has_many :surveys, through: :runs
  has_many :subscriptions
  has_many :gammas, through: :runs
  has_many :events
  has_many :tools, through: :events
  has_many :report_requests
  has_many :notifiers, as: :notifierable
  has_many :templates
  has_many :truck_requests

  scope :active, -> {where("updated_at > ?", 1.day.ago).where(inactive: false).order(updated_at: :desc)}
  scope :recent, -> {where("updated_at > ?", 1.week.ago).order(updated_at: :desc)}

  pg_search_scope :search,
                :against => :name,
                :using => {
                  :tsearch => {
                    :prefix => true
                  }
                }

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.search keywords
    if keywords.present? then where("name ilike ?", "%#{keywords}%") end
  end

  def invoices
    #had to go this route becuase can't call uniq on json fields
    ids = runs.select{|r| !r.invoice_id.blank?}.uniq.map(&:invoice_id)
    Invoice.find(ids)
  end

  def self.fuzzy_find(name)
    return nil unless name
    Job.find_by("lower(name) = ?", name.downcase.strip)
  end

  def well
    runs.joins(:well).first.try(:well)
  end

  def rig
    runs.joins(:rig).first.try(:rig)
  end

  def add_to_recent_updates update
    cache_will_change!
    updates = self.cache["recent_updates"][update.type] || []
    updates.shift unless updates.length < 5
    updates.push update.id unless updates.include?(update.id)
    save
  end

  def recent_updates_for_type type
    updates_history[type]
  end

  def last_update_for_type type
    self.recent_updates_for_type(type).try(:first)
  end

  def updates_history
    updates = self.cache["recent_updates"].dup || {}
    updates.each do |update_type, ids|
      updates[update_type] = Update.where(id: ids).order(time: :desc)
    end
  end
end