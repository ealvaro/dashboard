class V750::ToolsController < V710::ToolsController
  def tools
    if params[:order].blank? then order_by = 'created_at' else order_by = params[:order] end
    if params[:reverse] == 'false' then sort = 'desc' else sort = 'asc' end

    if !params[:search].blank?
      @tools = Tool.search(params[:search])
                   .order("cache ->> '#{order_by}' #{sort}")
                   .page(params[:page])

    elsif !params[:tool_type].blank?
      tool_type = ToolType.find_by_name params[:tool_type]
      @tools = tool_type.tools
                        .order("cache ->> '#{order_by}' #{sort}")
                        .page(params[:page])
    else
      @tools = Tool.includes( :tool_type )
                   .where("tool_types.name not in ('DD', 'MWD')")
                   .references(:tool_types)
                   .order("cache ->> '#{order_by}' #{sort}")
                   .page(params[:page])
    end
    render json: @tools, meta: { pages: @tools.total_pages, results: @tools.total_count }
  end

  def recent_memories
    if params[:order].blank? then order_by = 'time' else order_by = params[:order] end
    if params[:reverse] == 'true' then sort = 'asc' else sort = 'desc' end

    if params[:type].blank?
      @memories = Event.memories
                       .memory_search(params[:search])
                       .order(order_by.to_sym => sort.to_sym)
                       .page(params[:page])
    else
      @memories = ToolType.find_by_name(params[:type])
                          .events
                          .memories
                          .memory_search(params[:search])
                          .order(order_by.to_sym => sort.to_sym)
                          .page(params[:page])
    end
    render json: {
      memories: ActiveModel::ArraySerializer.new(@memories, each_serializer: EventSerializer),
      meta: { pages: @memories.total_pages,
        results: @memories.total_count }
    }
  end

  def tools_csv
    tool_type = params[:tool_type]
    if tool_type.present?
      tool_type = ToolType.find_by_name tool_type
      tools = tool_type.tools
    else
      tools = Tool.includes(:tool_type).load
    end
    render json: tools, root: false
  end

  def memories_csv
    if params[:type].blank?
      memories = Event.memories
    else
      memories = ToolType.find_by_name(params[:type])
                         .events
                         .memories
    end
    render json: memories.order(time: :desc).limit(500), each_serializer: EventSerializer, root: false
  end
end