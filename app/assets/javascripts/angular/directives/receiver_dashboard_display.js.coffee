Erdos.directive "receiverDashboardDisplay", () ->
  restrict: "AEC"
  replace: true
  templateUrl: "receiver_dashboard_display.html.erb"
  scope:
    jobNumber: "@"
    receiverType: "@"
    object: "="
    type: "="
    showHeaders: "="
    channels: "="
  controller: ($scope, Pusher) ->
    $scope.radar_channel = $scope.type + '-receiver-updated'
    $scope.table_channel = $scope.type + '-receiver-updated'
    $scope.pulse_channel = $scope.type + '-receiver-pulse'
    $scope.fft_channel = $scope.type + '-receiver-fft'

    $scope.channels.push $scope.table_channel unless $scope.channels.include? $scope.table_channel
