class V710::EventsController < V700::EventsController
  protected

  def event_params
    params.permit(:reporter_type, :software_installation_id, :board_firmware_version, :board_serial_number,
                  :chassis_serial_number, :primary_asset_number, :secondary_asset_numbers, :user_email, :region,
                  :notes, :hardware_version, :memory_usage_level, :reporter_version, :job_number, :run_number,
                  :reporter_context, :max_temperature, :max_shock, :shock_count, :client_name, :well_name, :rig_name, :run_id,
                  :team_viewer_id, :team_viewer_password, :can_id
    )
  end
end
