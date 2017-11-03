class V700::EventsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    tool = Tool.for_uid(params.fetch(:uid))
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
      event.job_id = params[:job_id] if Job.find_by(id: params[:job_id])
      event.run_id = params[:run_id] if Run.find_by(id: params[:run_id])
      event.well_id = params[:well_id] if Well.find_by(id: params[:well_id])
      event.rig_id = params[:rig_id] if Rig.find_by(id: params[:rig_id])
      event.client_id = params[:client_id] if Client.find_by(id: params[:client_id])
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
  end

  protected

  def event_params
    params.permit(:reporter_type, :software_installation_id, :board_firmware_version, :board_serial_number,
                  :chassis_serial_number, :primary_asset_number, :secondary_asset_numbers, :user_email, :region,
                  :notes, :hardware_version, :memory_usage_level, :reporter_version, :job_number, :run_number,
                  :reporter_context, :max_temperature, :max_shock, :shock_count, :client_name, :well_name, :rig_name, :run_id,
                  :team_viewer_id, :team_viewer_password
    )
  end
end
