class Billing::ToolsController < ApplicationController
  def index
    @tools_json = ActiveModel::ArraySerializer.new(Tool.billable, root: false).to_json
  end

  def show
    @tool = Tool.find(params[:id])
    @tool_json = ToolSerializer.new(@tool, root: false).to_json
  end
end