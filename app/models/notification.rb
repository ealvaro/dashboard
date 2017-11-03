class Notification < ActiveRecord::Base
  include SearchCategories

  # when rails 4.1 enum completed_status: [ :critical , :false_alarm , :resolved ]
  belongs_to :notifier

  #update
  belongs_to :notifiable, polymorphic: true
  belongs_to :user, :foreign_key => 'cleared_by_id'

  scope :active, -> {where("completed_at is null")}
  scope :old_active, ->(ago) {where("completed_at is null AND notifications.created_at < ?", ago)}
  scope :completed, -> {where("completed_at is not null")}
  scope :by_notifier, ->(notifier) {where("notifier_id = ?", notifier.id)}

  validates :completed_status,  :inclusion  => {:in => [ 'Critical', 'False Alarm', 'Resolved', 'Other' ],
                                                :message    => "%{value} is not a valid notification status" },
                                if: :completed?

  def self.by_job_number(job_number)
    by_job_numbers([job_number])
  end

  def self.by_job_numbers(job_numbers)
    Notification.joins("INNER JOIN updates ON notifications.notifiable_id = updates.id")
                .where(notifications: {notifiable_type: 'Update'})
                .where("lower(updates.job_number) in (?)", job_numbers.map(&:downcase))
  end

  def self.following(user)
    by_job_numbers(user.follows)
  end

  def self.users
    User.joins(:notifications).group("users.id")
  end

  def completed?
    !!completed_at
  end

  def complete!
    raise 'This alert has already been completed!' if completed?
    self.update_attributes completed_at: DateTime.now
  end

  def job_number
    if notifiable
      notifiable.try(:job_number)
    end
  end

  def self.search(keyword)
    if is_job_number? keyword
      search_by_job keyword
    elsif is_date? keyword
      search_by_date date_filter(keyword)
    else
      search_by_string keyword
    end
  end

  def self.search_by_job(keyword)
    by_job_number keyword
  end

  def self.search_by_date(keyword)
    where("created_at between :s and :e or
                  updated_at between :s and :e or
                  completed_at between :s and :e",
                  s: keyword.to_date.beginning_of_day, e: keyword.to_date.end_of_day)
  end

  def self.search_by_string(keyword)
    results = []
    user_ids = User.search(keyword).pluck :id
    results.push where(cleared_by_id: user_ids).pluck :id
    results.push where("completed_status @@ :k
                              or description @@ :k",
                              k: keyword).pluck :id
    where(id: results.flatten.uniq)
  end

  def self.not_template
    includes(:notifier)
      .where.not(notifiers: { type: "TemplateNotifier" } )
      .references(:notifiers)
  end

  def self.template_notifications_for_user(user)
    templates = Template.where(user: user)
    includes(:notifier)
      .where(notifiers: { notifierable_type: 'Template' })
      .where(notifiers: { notifierable_id: templates })
      .references(:notifiers)
  end

  def self.followed_template_notifications(user)
    following_notifications = following(user)
    template_notifications = template_notifications_for_user(user)
    intersect = following_notifications & template_notifications
  end
end
