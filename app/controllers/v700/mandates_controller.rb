class V700::MandatesController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    render json: Mandate.active, root: false
  end
end
