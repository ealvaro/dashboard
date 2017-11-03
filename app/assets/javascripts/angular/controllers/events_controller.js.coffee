Erdos.controller "EventsController", ($scope, $http) ->
  $scope.init = ( event_string ) ->
    $scope.event = JSON.parse( event_string )

  $scope.hasConfigs = ->
    $scope.event && $scope.event.configs && Object.keys($scope.event.configs).length > 0
