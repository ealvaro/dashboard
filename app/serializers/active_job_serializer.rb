class ActiveJobSerializer < JobShallowSerializer
  attributes :job, :client, :rig, :run, :well, :last_updates,
             :start_time, :has_active_alert, :inactive, :activity

  def job
    object.name.try :upcase
  end

  def client
    object.client.try(:name)
  end

  def rig
    object.rig.try(:name)
  end

  def run
    object.runs.last.try :number
  end

  def well
    object.well.try :name
  end

  def start_time
    object.created_at
  end

  def last_updates
    Update.children.inject({}) { |h, u| h[u.to_s] = u.last_update_for_job object.name; h }
  end

  def has_active_alert
    Notification.search_by_job(object.name).active.present?
  end

  def activity
    if object.updated_at > 1.day.ago && !object.inactive
      "Active"
    else
      "Inactive"
    end
  end
end
