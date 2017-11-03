class EventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :time, :reporter_type, :software_installation_id, :board_firmware_version, :board_serial_number
  attributes :chassis_serial_number, :primary_asset_number, :secondary_asset_numbers, :user_email, :region, :notes
  attributes :job_number, :run_number, :reporter_context, :hardware_version, :reporter_version, :configs, :memory_usage_level
  attributes :max_temperature, :max_shock, :shock_count, :created_at, :team_viewer_id, :team_viewer_password
  attributes :job_id, :run_id, :well_id, :rig_id, :client_id
  attributes :show_url, :tool_type_name, :tool_uid, :can_id
  attributes :user_name

  has_many :event_assets, include: true

  def user_name
    user = User.find_by(email: object.user_email)
    !user.blank? ? user.name : nil
  end

  def job_number
    object.job_number || object.try(:job).try(:name)
  end

  def reporter_type
    if 0
      "LConfig"
    else
      "Unknown"
    end
  end

  def tool_uid
    object.tool.uid
  end

  def tool_type_name
    object.tool.tool_type.name
  end

  def reporter_context
    return "" if object.reporter_context.blank?
    rc = object.reporter_context.downcase
    if rc.include? "debugger"
      "Debugger"
    elsif rc.include? "admin"
      "Admin"
    elsif rc.include? "service"
      "Service"
    elsif rc.include? "Field"
      "Field"
    else
      object.reporter_context
    end
  end

  def show_url
    event_path( object )
  end
end
