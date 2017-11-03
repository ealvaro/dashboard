Erdos.filter 'unique', ->
  return (arr, field) ->
    _.uniq arr, (a) ->
      return a[field]
