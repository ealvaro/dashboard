Erdos.filter('toolFilter', () ->
  (tools, tool_type_name) ->
    result = []
    if( tools )
      for tool in tools
        if tool_type_name.length == 0 || ( tool && tool.tool_type.name == tool_type_name )
          result.push( tool )
    result
)
