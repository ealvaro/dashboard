class Push::RegionsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    render json: Region.all
  end
end
