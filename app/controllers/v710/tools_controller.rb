class V710::ToolsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    @tool = Tool.new uid: params[:uid], tool_type: ToolType.find_by(number: params[:tool_type]), serial_number: params[:serial_number]
    if @tool.save
      render json: @tool
    else
      render json: @tool.errors.as_json, status: :bad_request
    end
  end
end