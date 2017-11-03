Erdos.filter('abbreviationFilter', () ->
  (name) ->
    result = ""
    if( name )
      if( name.indexOf('-') == -1 )
        result = name.replace(/[a-z ]+/g, "" )
      else
        result = name.replace("- ", "").replace("Configuration", "Config").replace("Status ", "")
    result
)
