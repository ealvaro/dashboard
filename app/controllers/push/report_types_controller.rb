class Push::ReportTypesController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    @reports = ReportType.active
    render json: @reports, root: false
  end
end
