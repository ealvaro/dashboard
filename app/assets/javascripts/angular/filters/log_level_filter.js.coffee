Erdos.filter('logLevel', () ->
  (import_updates, log_level) ->
    result = []
    return import_updates if( log_level == "VERBOSE" )
    if import_updates && import_updates.length > 0
      for update in import_updates
        result.push update if update.update_type == log_level || update.update_type == "FINISHED"
    result
)
