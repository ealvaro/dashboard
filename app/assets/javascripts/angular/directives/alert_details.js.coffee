Erdos.directive "alertDetails", (AlertUtils) ->
  restrict: 'E'
  replace: true
  templateUrl: "alert_details.html.erb"
  scope:
    object: "="
  controller: ($scope) ->
    $scope.hide = () ->
      $scope.object.details = false

    $scope.ignore = (alert) ->
      AlertUtils.ignore(alert)

    $scope.complete = (alert) ->
      AlertUtils.complete(alert)
