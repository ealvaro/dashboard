Erdos.filter('eventTypeFilter', () ->
  (events, event_types) ->
    result = []
    if( events && event_types )
      for event in events
        if event_types.indexOf( event.event_type ) >= 0
          result.push event
    result
)
