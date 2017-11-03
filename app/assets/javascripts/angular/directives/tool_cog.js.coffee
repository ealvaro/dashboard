Erdos.directive "toolCog", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "tool_cog.html"
  scope:
    tool: "=object"
    tools: "=objects"
    currentUser: "="
  controller: ($scope) ->
    $scope.showDetails = ->
      $scope.tool.details = true

    $scope.deleteTool = ->
      tool = $scope.tool
      if confirm( "Are you sure you want to destroy this tool? This operation is irreversible." ) == true
        url = tool.destroy_url
        $http( {method: 'DELETE', id: tool.id, url: url } ).success ( response ) ->
          index = $scope.tools.indexOf( tool )
          $scope.tools.splice( index, 1 )

    $scope.isStatus = (status) ->
      $scope.tool.cache.status == status

    $scope.setStatus = (tool, status) ->
      event_type_id = $scope.getId(status)
      reporter_type = "1"
      time = new Date()
      time = time.getTime()
      uid = tool.uid
      $http({method: "POST", url: "/push/tools/events", data: {event_type_id: event_type_id, reporter_type: reporter_type, time: time, uid: uid, current_user:true}}).success (response) ->
        $scope.tool.cache.status = response.event.event_type

    $scope.getId = (status) ->
      if status.indexOf("In Service") > -1
        return 12
      else if status.indexOf("In Development") > -1
        return 13
      else if status.indexOf("In Repair") > -1
        return 14
      else if status.indexOf("Preemptive Replacement") > -1
        return 15
      else if status.indexOf("Down-hole Failure") > -1
        return 16
      else if status.indexOf("Shop Damage") > -1
        return 17
      else
        false

    $scope.canMerge = ->
      $scope.currentUser && ($scope.currentUser.email == "kenneth@erdosmiller.com" || $scope.currentUser.email == "joshua.wolfe@erdosmiller.com")

    $scope.launchMerge = ->
      window.open( '/tools/' + $scope.tool.uid + '/merge' )
