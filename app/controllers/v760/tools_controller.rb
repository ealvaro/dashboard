class V760::ToolsController < V750::ToolsController
  def create
    tool_type = ToolType.find_by_number tool_params[:tool_type]
    @tool = (Tool.find_by(uid: tool_params[:uid]) ||
            Tool.find_by(tool_type: tool_type,
                         serial_number: tool_params[:serial_number]) ||
            Tool.new(uid: tool_params[:uid],
                     serial_number: tool_params[:serial_number],
                     tool_type: tool_type)
            )

    if @tool.save
      render json: @tool
    else
      render json: @tool.errors.as_json, status: :bad_request
    end
  end

  def new_dumb_tool
    tool = Tool.new
    tool.tool_type = ToolType.find_by_number params[:tool_type]

    if tool.save
      render json: tool.to_json(only: [:id])
    else
      render json: { message: tool.errors }, status: 422
    end
  end

  private

    def tool_params
      params.require(:tool).permit(:uid, :serial_number, :tool_type)
    end
end