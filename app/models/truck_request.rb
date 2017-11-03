class TruckRequest < ActiveRecord::Base
  include SearchCategories
  before_save :parse_time

  belongs_to :job
  belongs_to :region

  scope :active, -> { where.not("lower(status ->> 'context') in (?)", ['received', 'shipped']) }
  scope :completed, -> { where("lower(status ->> 'context') in (?)", ['received', 'shipped']) }

  validates :job, presence: true

  def self.sort_by_priority
    array = []
    grouped = self.order(updated_at: :desc).group_by(&:priority)
    priority_order = ["high", "medium", "low"]
    priority_order.each do |priority|
      array.push grouped[priority]
    end
    array.compact.flatten
  end

  def self.search keyword
    if is_date?(keyword)
      keyword = date_filter(keyword)
      where("created_at between :s and :e",
            s: keyword.to_date.beginning_of_day,
            e: keyword.to_date.end_of_day)
    else
      where("priority @@ :k OR
             status ->> 'context' @@ :k OR
             user_email @@ :k OR
             computer_identifier @@ :k OR
             motors @@ :k OR
             mwd_tools @@ :k OR
             surface_equipment @@ :k OR
             backhaul @@ :k OR
             status ->> 'notes' @@ :k OR
             jobs.name @@ :k OR
             regions.name @@ :k
             ", k: keyword).includes(:job, :region).references(:jobs, :regions)
    end
  end

  def status=(options)
    unless self.status["context"] == options["context"]
      status_history_will_change!
      self[:status_history] = self[:status_history].push(self[:status]) if self.status.present?
      self[:status] = options
    end
  end

  def status_list
    list = self.status_history.push(self.status).dup
    list.each do |status|
      status["context"] = status["context"].try(:capitalize)
    end
    list
  end

  def mwd_tools=(options)
    self[:mwd_tools] = force_utf8(options)
  end

  def motors=(options)
    self[:motors] = force_utf8(options)
  end

  def surface_equipment=(options)
    self[:surface_equipment] = force_utf8(options)
  end

  def backhaul=(options)
    self[:backhaul] = force_utf8(options)
  end

  private

    def force_utf8 str
      str.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end

    def parse_time
      return nil unless self.status["time"].present?
      self.status["time"] = self.status["time"].try(:to_time).try(:to_s)
    end
end