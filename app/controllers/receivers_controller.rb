class ReceiversController < ApplicationController
  before_action :authenticate_user!

  def index
  #   @receivers = ToolType.find_by(number: 4).tools.load
  end

  def show
    @receiver = Tool.find_by! uid: params[:id]
  end

end
