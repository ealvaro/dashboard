class Push::ToolsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def show
    @tool = Tool.find_by(serial_number: params[:serial_number]) if params[:serial_number]
    @tool ||= Tool.for_uid(params.fetch(:id))
    render json: @tool
  rescue ActiveRecord::RecordNotFound
    render text: "Not Found", status: 404
  end

  def recent_memories
    limit = params[:limit] || 500
    render json: Event.includes( :event_assets ).where( event_type: "Memory - Download" ).order(time: :desc).limit( limit ), root: false
  end

  def create
    tool_type = ToolType.find_by!(number: params[:tool_type])
    @tool = Tool.create! tool_type: tool_type, serial_number: params[:serial_number]
    render json: @tool
  end

  def events
    uid = params.fetch(:uid, nil)
    if uid.present?
      tool = Tool.for_uid(uid)
      event = tool.events.build event_params
      ea = nil
      ActiveRecord::Base.transaction do
        event.event_type = EventType.find( params[:event_type_id].to_i ).name
        event.time = Time.at(params[:time].to_i)
        event.configs = params[:configuration]
        event.tags = params[:tags]
        event.user_email = current_user.email if params[:current_user]
        rt = ReportType.find(params[:report_type_id]) if params[:report_type_id]
        event.report_type_id = rt.id if rt
        event.save
        if params[:assets]
          params[:assets].each do |key, value|
            ea = event.event_assets.build
            ea["name"] = key
            ea["file"] = value
            break unless ea.save
          end
        end
      end
      event.notify!
      if ( ea.nil? || ea.valid? ) && event.valid?
        render json: event
      elsif ( !event.valid? )
        render json: event.errors, status: 400
      else
        render json: ea.errors, status: 400
      end
    else
      render json: {error: "missing uid"}, status: :bad_request
    end
  end

  def event_history
    tool = Tool.for_uid(params.fetch(:id))
    render json: tool.events.order(time: :desc), root: false
  end

  def index
    render json: Tool.includes( :tool_type ).where("tool_types.name not in ('DD', 'MWD')").references(:tool_types), root: false
  end

  def event_types
    render json: EventType.events.map{|e| e.name }, root: false
  end

  def destroy
    @tool = Tool.find( params[:id] )
    @tool.destroy
    render json: @tool, root: false
  end

  def to_csv
    current_user.create_export! params[:objects_array]
    render json: current_user.exports.last
  end

  protected

  def event_params
    params.permit(:reporter_type, :software_installation_id, :board_firmware_version, :board_serial_number,
                  :chassis_serial_number, :primary_asset_number, :secondary_asset_numbers, :user_email, :region,
                  :notes, :hardware_version, :memory_usage_level, :reporter_version, :job_number, :run_number,
                  :reporter_context, :max_temperature, :max_shock, :shock_count, :client_name, :well_name, :rig_name, :run_id,
                  :team_viewer_id, :team_viewer_password)
  end
end
