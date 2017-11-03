class Push::PricingSchemesController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def current_scheme
    @pricing_scheme = Client.find(params[:client_id]).pricing
    render json: @pricing_scheme, root: false
  end

  def show
    @pricing_scheme = PricingScheme.find(params[:id])
    render json: @pricing_scheme, root: false
  end

  def update
    old_scheme = PricingScheme.find(params[:id])
    @pricing_scheme = old_scheme.client.pricing_schemes.create!(pricing_scheme_params)
    render json: @pricing_scheme, root: false
  end

  private

  def pricing_scheme_params
    params.require(:pricing_scheme).permit!.select{|k,v| [:max_temperature, :max_shock, :max_vibe, :shock_warnings, :motor_bend, :rpm, :agitator_distance, :mud_type, :dd_hours, :mwd_hours, :client_id].include? k.to_sym}
  end
end
