class PricingSchemesController < ApplicationController
  def show
    @pricing_scheme = PricingScheme.find(params[:id])
  end

  def current_scheme
    @pricing_scheme = Client.find(params[:client_id]).pricing
    render :show
  end
end