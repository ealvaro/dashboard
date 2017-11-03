Erdos.filter('runDamageFilter', () ->
  (damages_as_billed) ->
    result = {}
    if( damages_as_billed )
      for key in Object.keys( damages_as_billed )
        if damages_as_billed[key].amount > 0 || damages_as_billed[key].altered
          result[key] = damages_as_billed[key]
    result
)
