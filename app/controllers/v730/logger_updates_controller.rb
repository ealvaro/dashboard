class V730::LoggerUpdatesController < ApplicationController
  include Utilities
  include TokenAuthenticating
  respond_to :json

  def create
    update = LoggerUpdate.new object_params

    fill_info_params(update)

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
    update.job_number = strip_and_upcase params[:job]
    update.run_number = strip_and_upcase params[:run]
    update.well_name = strip_and_upcase params[:well]
    update.client_name = strip_and_upcase params[:client]
    update.rig_name = strip_and_upcase params[:rig]

    update.pumps_on = string_to_boolean(params[:pumps_on])
    update.on_bottom = string_to_boolean(params[:on_bottom])
    update.slips_out = string_to_boolean(params[:slips_out])
  end

  def object_params
    params.permit( :software_installation_id, :team_viewer_id, :bore_pressure, :mag_roll,
                   :team_viewer_password, :block_height, :hookload, :annular_pressure, :pump_pressure, :bit_depth, :weight_on_bit, :rotary_rpm,
                   :rop, :voltage, :inc, :azm, :api, :hole_depth, :gravity, :grav_roll, :dipa, :survey_md, :survey_tvd, :survey_vs,
                   :temperature, :pumps_on, :on_bottom, :slips_out, :gama, :gamma_shock, :gamma_shock_axial_p, :gamma_shock_tran_p, :decode_percentage, :magf,
                   :average_quality, :atfa, :gtfa, :mtfa, :formation_resistance, :delta_mtf,
                   :mx, :my, :mz, :ax, :ay, :az, :batv, :batw, :dipw, :gravw, :reporter_version,
                   :gv0, :gv1, :gv2, :gv3, :gv4, :gv5, :gv6, :gv7)
  end
end
