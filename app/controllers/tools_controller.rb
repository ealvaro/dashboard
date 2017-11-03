class ToolsController < ApplicationController
  before_action :authenticate_user!

  # /tools
  def tools_list
    # @tool_types = ToolType.all.erdos_miller.preload(:tools).order(:name)
    #@tools = Tool.all.order( created_at: :asc )
    #@tools_json = ActiveModel::ArraySerializer.new( @tools, each_serializer: ToolSerializer ).to_json
  end

  # /tools/type/:id
  def tools
    # tools for a type
    @tool_type = ToolType.find(params[:id])
    @tools = @tool_type.tools.order("created_at DESC").page( params[:page] )
  end

  # /tools/list/:id
  def show
    # specific tool
    @tool = Tool.find(params[:id]).decorate
    @tool_json = ToolSerializer.new( @tool, root: false ).to_json
  end

  # /tools/list/:id/events
  def events
    @tool = Tool.find(params[:id]).decorate
  end

  # /tools/:id
  def destroy
    #Tool.find(params[:id]).destroy
    redirect_to :tools
  end

  #/tools/:id/merge
  def merge
    @tool = Tool.find_by(uid: params[:id])
    @tools = @tool.tool_type.tools.where("uid != ?", @tool.uid).order(uid: :asc)
  end

  def merge_tools
    @sub_tool = Tool.find_by(uid: params[:id])
    @tool = Tool.find_by(uid: params[:into_tool])
    return redirect_to 'tools/merge' if @tool.id == @sub_tool.id
    @tool.merge!(@sub_tool)
    return redirect_to :tools
  end

  def histograms
    @tool = Tool.find(params[:id])
    @histograms = @tool.histograms
    @jobs = @histograms.map { |h| { id: h.job_id, name: h.job.name } }.uniq
    @runs = @histograms.map { |h| { job_id: h.job_id, id: h.run.id, number: h.run_number } }.uniq
  end

end