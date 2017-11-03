class SearchEventsQuery

  def initialize(tool, options={})
    @tool = tool
    @page = options[:page]
    @per_page = options[:per_page] || 30
    @event_types = options[:event_types]
  end

  def find
    events = @tool.events

    unless @event_types.nil?
      events = events.where(event_type: @event_types)
    end

    events.order("time desc, id desc").page(@page).per(@per_page)
  end

end
