Erdos.filter('installType', () ->
  (installs, type_name) ->
    result = []
    if( installs )
      for install in installs
        if type_name.length == 0 || ( install.application_name == type_name )
          result.push( install )
    result
)
