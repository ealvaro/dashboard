Erdos.controller "NavbarController", ($scope, $http, $rootScope, AlertUtils) ->
  $scope.init = ->
    $scope.expanded = false

  $scope.expand = ->
    if $scope.expanded
      $scope.expanded = false
    else
      $scope.expanded = true

  $scope.getDate = (date) ->
    if date
      moment( Date.parse( date ) )
    else
      undefined

  $scope.ignore = (alert) ->
    AlertUtils.ignore(alert)

  $scope.complete = (alert) ->
    AlertUtils.complete(alert)
