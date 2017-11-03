Erdos.directive "erdosReceiverLoggingTable", (Pusher, $http) ->
  restrict: 'E'
  replace: true
  scope:
    jobNumber: '='
    jobId: '='
  templateUrl: "erdos_receiver_logging_table.html.erb"
  controller: ($scope) ->
    $scope.tab = 'Live'
    $scope.$on "logger-updated", (evt, message) ->
      $scope.logger_data = message

    $scope.dataPoints = {
                          "slips_out": "Slips Out",
                          "on_bottom": "On Bottom",
                          "pumps_on": "Pumps On",
                          "block_height": "Block Height",
                          "hookload": "Hookload",
                          "pump_pressure": "Pump Pressure",
                          "rotary_rpm": "Rotary RPM",
                          "bit_depth": "Bit Depth",
                          "weight_on_bit": "WOB",
                          "hole_depth": "Hole Depth",
                          "rop": "ROP",
                          "inc": "Inclination",
                          "azm": "Azimuth",
                          "api": "API",
                          "dipa": "Dip Angle",
                          "survey_md": "Survey MD",
                          "survey_tvd": "Survey",
                          "survey_vs": "Survey VS"
                        }

    $scope.keyContains = (object) ->
      _.contains(Object.keys($scope.dataPoints), object)

    $scope.changeTab = (tab) ->
      $scope.tab = tab

    $scope.fetchUpdatesHistory = ->
      if $scope.jobId?
        $http.get("/push/jobs/#{$scope.jobId}/recent_updates?type=LoggerUpdate").then (response) ->
          $scope.history = response.data
