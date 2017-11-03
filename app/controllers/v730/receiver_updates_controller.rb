class V730::ReceiverUpdatesController < ApplicationController
  include UpdateHelpers
  include Utilities
  include TokenAuthenticating
  respond_to :json

  # Provides the starting version of Receiver Updates creation.
  def create
    update_class = update_class_from_type params[:receiver_type]
    update = update_class.new(object_params)

    fill_info_params(update)

    update.tool_face_data = params[:tool_face_data]
    update.pulse_data = params[:pulse_data]
    update.table = params[:table]

    if update.save
      update.rig.try(:touch)
      UpdateNotifier.trigger(update)
      render json: {id: update.id}
    else
      render json: update.errors, status: :bad_request
    end
  end

  private

  def fill_info_params(update)
    update.time = params[:time_stamp]
    update.temperature = params[:temp] if params[:temp].present?
    update.low_pulse_threshold = params[:low_pulse_threshold]

    update.job_number = strip_and_upcase params[:job]
    update.run_number = strip_and_upcase params[:run]
    update.well_name = strip_and_upcase params[:well]
    update.client_name = strip_and_upcase params[:client]
    update.rig_name = strip_and_upcase params[:rig]

    update.tempw = string_to_boolean params[:tempw]
    update.magw = string_to_boolean params[:magw]
    update.dl_enabled = string_to_boolean params.try(:[],:dl_enabled)
    update.batw = string_to_boolean params[:batw]
    update.gravw = string_to_boolean params[:gravw]
    update.dipw = string_to_boolean params[:dipw]
    update.bat2 = string_to_boolean params[:bat2]
  end

  def param_list
    [
      :dao, :reporter_version, :software_installation_id, :team_viewer_id, :team_viewer_password, :power, :dl_power, :frequency, :signal, :mag_dec, :s_n_ratio, :noise, :battery_number,
      :decode_percentage, :hole_depth, :bit_depth, :pump_on_time, :pump_off_time, :pump_total_time, :inc, :azm, :gravity, :grav_roll, :mag_roll, :magf, :dipa,
      :gama, :gamma_shock, :gamma_shock_axial_p, :gamma_shock_tran_p, :atfa, :gtfa, :mtfa, :delta_mtf, :formation_resistance, :mx, :my, :mz, :ax, :ay, :az, :batv, :batw, :bat2, :dipw, :gravw, :gv0, :gv1,
      :gv2, :gv3, :gv4, :gv5, :gv6, :gv7, :magw, :dl_enabled, :tempw, :sync_marker, :survey_sequence, :logging_sequence,
      :confidence_level, :average_quality, :pump_state, :tf, :tfo, :annular_pressure, :bore_pressure, :pump_pressure, :low_pulse_threshold, :average_pulse
    ]
  end

  def object_params
    params.permit(*param_list)
  end
end
