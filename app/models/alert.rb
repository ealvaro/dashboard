class Alert < ActiveRecord::Base
  after_initialize :raise_initialization_error
  after_create :deliver_pusher
  after_update :deliver_pusher

  belongs_to :requester, class_name: "User"
  belongs_to :assignee, class_name: "User"

  belongs_to :alertable, polymorphic: true

  validates :severity, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 2}
  validates :assignee_id, presence: true

  scope :recent, -> {where("created_at > ?", 1.month.ago.to_s(:db))}
  scope :completed, -> {where('completed_at is not null')}

  def completed?
    !!completed_at
  end

  def ignored?
    !!ignored_at
  end

  def canceled?
    !!canceled_at
  end

  def pending?
    !(ignored_at || completed_at || canceled_at)
  end

  def ignore!
    raise 'You cannot ignore a completed alert!' if completed?
    self.update_attributes ignored_at: DateTime.now
  end

  def complete!
    raise 'This alert has already been completed!' if completed?
    self.update_attributes completed_at: DateTime.now
  end

  def cancel!
    raise 'This alert is not pending!' if completed? || ignored?
    self.update_attributes canceled_at: DateTime.now
  end

  def job
    job_id ? Job.find(job_id) : run.job
  end

  def alertable_json
    # can be overridden by children
    alertable.as_json.merge(job: {name: alertable.job.name, show_url: Rails.application.routes.url_helpers.job_path(alertable.job)}, run: {number: alertable.run.number, show_url: Rails.application.routes.url_helpers.run_path(alertable.run)})
  end

  def pusher_json
    # can be overridden by children
    as_json
  end

  private

    def deliver_pusher
      Pusher["user-#{assignee_id}"].trigger("alert", pusher_json)
    end

    def raise_initialization_error
      raise 'You cannot initialize a generic Alert' if self.class.name == 'Alert'
    end
end
