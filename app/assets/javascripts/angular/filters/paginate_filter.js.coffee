Erdos.filter('paginate', () ->
  (objects, currentPage, perPage) ->
    result = []
    if( objects )
      start_index = ( parseInt(currentPage) - 1 ) * parseInt(perPage)
      end_index = start_index + parseInt(perPage)
      return objects.slice(start_index, end_index)
    result
)
