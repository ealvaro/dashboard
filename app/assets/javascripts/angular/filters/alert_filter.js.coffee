Erdos.filter 'alert', () ->
  (alerts, status) ->
    result = []
    if( alerts )
      for alert in alerts
        if status == 'completed'
          result.push alert if alert.completed
        else if status == 'ignored'
          result.push alert if alert.ignored
        else
          if alert.completed == false && alert.ignored == false
            result.push alert

    result
