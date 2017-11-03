class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :notifier, :created_at, :updated_at
  attributes :completed_at, :completed_status, :completed_by
  attributes :description
  attributes :completed, :job_number

  def completed
    object.completed?
  end

  def job_number
    object.job_number
  end

  def completed_by
    object.try(:user).try(:email)
  end
end
