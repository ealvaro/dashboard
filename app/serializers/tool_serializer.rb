class ToolSerializer < ActiveModel::Serializer
  attributes :id, :uid, :uid_display, :cache, :tool_events_url, :show_url, :destroy_url, :active_url, :serial_number
  attributes :billing_show_url, :updated_at, :created_at, :total_service_time
  has_one :tool_type

  def tool_events_url
    events_path( object )
  end

  def show_url
    tool_path( object )
  end

  def billing_show_url
    billing_tool_path( object )
  end

  def active_url
    object.receiver? ? active_job_dashboard_path(id: object.id) : nil
  end

  def cache
    object.cache
  end

  def destroy_url
    object && defined?( current_user ) && object.deletable_by?( current_user ) ? '/push/tools/' + object.id.to_s : nil
  end

  def total_service_time
    object.total_service_time
  end

end