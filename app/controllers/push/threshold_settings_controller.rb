class Push::ThresholdSettingsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    ts_params = params[:pump_off_time_in_minutes].present? ? threshold_params.merge(threshold_params[:pump_off_time_in_minutes] * 1000) : threshold_params
    render json: ThresholdSetting.create( ts_params ), root:false
  end

  private
  def threshold_params
    params.require(:threshold_setting).permit(:id,
                  :name,
                  :user_id,
                  :pump_off_time_in_milliseconds,
                  :max_temperature,
                  :max_batv,
                  :min_batv,
                  :batw,
                  :dipw,
                  :gravw,
                  :magw,
                  :tempw,
                  :min_confidence_level )
  end
end
