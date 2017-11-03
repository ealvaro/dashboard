Erdos.directive "alertsCog", ($http) ->
  restrict: 'AEC'
  replace: true
  templateUrl: "alerts_cog.html"
  scope:
    object: "="
  controller: ($scope, $http) ->
    $scope.checkClicked = (event, object, status) ->
      event.preventDefault()
      if !object.completed
        $http({method: "PUT", url: '/v750/notifications/complete/', data: {notification_id: object.id, status: status}})
