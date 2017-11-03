Erdos.directive "regenScriptDisplay", (Pusher) ->
  restrict: 'E'
  replace: true
  scope:
    jobNumber: '='
  templateUrl: "regen_script_display.html"
  controller: ($scope, $element) ->
    $scope.objects = []

    Pusher.subscribe "regen-script-" + $scope.jobNumber, 'update', (message) ->
      if applicable(message)
        index = _.chain($scope.objects).pluck("report_request_id")
                 .indexOf(message.report_request_id).value()
        if index > -1
          $scope.objects[index] = message
        else
          $scope.objects.push message

        $scope.objects = _.sortBy($scope.objects, (d) ->
          d.updated_at)

    applicable = (message) ->
      return $scope.jobNumber &&
        $scope.jobNumber.toLowerCase() == message.job_number.toLowerCase()

    $scope.scriptStatus = (object) ->
      switch
        when object.succeeded then "Succeeded"
        when object.failed then "Failed"
        else "Running"
