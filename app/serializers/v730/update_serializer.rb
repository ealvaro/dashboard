class V730::UpdateSerializer < ActiveModel::Serializer
  attributes :time_stamp, :updated_at, :created_at, :job_number, :job_id, :job, :id, :time, :run_number, :run_id, :run, :client_name,
             :client_id, :client, :rig_name, :rig_id, :well_name, :well_id, :well, :team_viewer_id, :team_viewer_password, :software_installation_id,
             :type, :has_active_alert

  def job
    job = object.job
    job ||= object.run.try(:job)
    object.job_number || object.job.try(:number)
  end

  def run
    object.run_number || object.run.try(:number)
  end

  def client
    object.client_name || object.client.try(:name)
  end

  def rig
    object.rig_name || object.rig.try(:name)
  end

  def well
    object.well_name || object.well.try(:name)
  end

  def time_stamp
    if time = object.time
      time.is_a?( ActiveSupport::TimeWithZone ) ? time : DateTime.parse(object.time)
    end
  end

  def has_active_alert
    Notification.search_by_job(job).active.present?
  end
end