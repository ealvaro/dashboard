Erdos.controller "ToolEventHistoryController", ($scope, $http) ->
  $scope.init = (uid) ->
    $scope.tool_uid = uid
    $scope.loading = true
    $scope.order_by = ""
    $scope.reverse = false
    $scope.event_types = []
    $scope.available_event_types = []

    $http({
      method: "GET",
      url: "/push/tools/#{$scope.tool_uid}/event_history"
    }).success (response) ->
      $scope.loading = false
      $scope.events = response
      for event in $scope.events
        if $scope.events.indexOf( event.event_type ) == -1 && $scope.available_event_types.indexOf( event.event_type ) == -1
          $scope.available_event_types.push( event.event_type )
      $scope.event_types = angular.copy( $scope.available_event_types )


    $scope.addType = (type) ->
      $scope.event_types.push type

    $scope.removeType = (type) ->
      index = $scope.event_types.indexOf( type )
      $scope.event_types.splice( index, 1 )

    $scope.getHiddenTypes = () ->
      if $scope.available_event_types.length > 0
        $scope.available_event_types.filter (x) ->
          $scope.event_types.indexOf( x ) == -1

    $scope.setOrderBy = ( string ) ->
      if $scope.order_by = string
        $scope.reverse = !$scope.reverse
      else
        $scope.order_by = string
        $scope.reverse = false

    $scope.getDate = (event, attr) ->
      if event && event[attr]
        moment( Date.parse( event[attr] ) )
      else
        undefined
