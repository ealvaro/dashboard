class AlertSerializer < ActiveModel::Serializer
  attributes :id, :errors, :type, :subject, :description, :ignored_at, :completed_at, :severity, :type, :created_at, :updated_at
  attributes :ignored, :completed, :canceled, :alertable_link, :type, :pending
  attributes :requester, :assignee, :alertable

  def alertable_link
    if object.try(:alertable)
      if object.try(:alertable_link)
        object.alertable_link
      else
        polymorphic_path(object.alertable)
      end
    else
      nil
    end
  end

  def completed
    object.completed?
  end

  def ignored
    object.ignored?
  end

  def canceled
    object.canceled?
  end

  def pending
    object.pending?
  end

  def requester
    {email: object.try(:requester).try(:email)}
  end

  def assignee
    {email: object.try(:assignee).try(:email)}
  end

  def alertable
    object.alertable_json
  end
end
