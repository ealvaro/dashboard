Erdos.directive "erdosReceiverJobHeader", () ->
  restrict: 'E'
  replace: true
  scope:
    channels: '='
  templateUrl: "erdos_receiver_job_header.html"
  controller: ($scope) ->
    for channel in $scope.channels
      $scope.$on channel, (evt, message) ->
        $scope.receiver_data = message

    $scope.getDate = (value)->
      result = Date.parse(value)
      if isNaN(result)
        return ""
      result
