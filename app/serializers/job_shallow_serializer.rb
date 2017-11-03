class JobShallowSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at, :show_url, :edit_url, :client_id, :client, :active_url

  def show_url
    job_path( object )
  end

  def edit_url
    edit_job_path( object )
  end

  def active_url
    active_job_dashboard_path(object)
  end
end
