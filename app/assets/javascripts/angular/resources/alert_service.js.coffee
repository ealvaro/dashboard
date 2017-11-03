Erdos.service 'AlertUtils', ($http) ->
  ignore: (alert) ->
    $http({method: "PUT", url: '/push/alerts/' + alert.id + "/ignore"})

  complete: (alert) ->
    $http({method: "PUT", url: '/push/alerts/' + alert.id + "/complete"})
