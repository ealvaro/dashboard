Erdos.filter 'memories', () ->
  (events) ->
    map = {}
    result = []
    if( events )
      for event in events
        if event.event_type == "Memory - Download"
          map[event.tool_uid] = event
    for key in Object.keys(map)
      result.push map[key]
    result
