class Push::ClientsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    if params[:shallow]
      render json: Client.visible, root: false, each_serializer: ClientIndexSerializer
    elsif params[:basic]
      render json: Client.visible.to_json(only: [:id, :name]), root: false
    else
      render json: Client.visible, root: false
    end
  end

  def show
    render json: Client.find(params[:id]), root: false
  end
end
