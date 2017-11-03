Erdos.filter('reporterContextFilter', () ->
  (rc) ->
    return "" if !rc
    if rc.toLowerCase().indexOf( "debug" ) >= 0
      "Debug"
    else if rc.toLowerCase().indexOf( "admin" ) >= 0
      "Admin"
    else if rc.toLowerCase().indexOf( "service" ) >= 0
      "Admin"
    else if rc.toLowerCase().indexOf( "field" ) >= 0
      "Field"
    else
      rc
)
