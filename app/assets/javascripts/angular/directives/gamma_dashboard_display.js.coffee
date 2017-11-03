Erdos.directive "gammaDashboardDisplay", ($resource, Pusher) ->
  restrict: 'E'
  replace: true
  scope:
    jobId: '='
    jobNumber: '='
  templateUrl: "gamma_dashboard_display.html"
  controller: ($scope, $element) ->
    Pusher.subscribe "gamma-" + $scope.jobNumber, 'update', (message) ->
      if applicable(message)
        $scope.$root.$broadcast 'gamma-update', message

    applicable = (message) ->
      return true if $scope.jobNumber &&
        $scope.jobNumber.toLowerCase() == message.job_number.toLowerCase()

    $scope.job_id = () -> $scope.jobId

    $scope.refreshGamma = () ->
      $scope.$root.$broadcast 'gamma-loading'
      Gamma = $resource '/v730/gammas/refresh/?job_id=:jobId'
      Gamma.get {jobId: $scope.jobId}, (response) ->
        $scope.$root.$broadcast 'gamma-refresh', response

    $scope.refreshGamma()
