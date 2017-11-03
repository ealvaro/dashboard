Erdos.directive "erdosReceiverTableEm", ($http) ->
  restrict: 'E'
  replace: true
  scope:
    channel: '='
  templateUrl: "erdos_receiver_table_em.html"
  controller: ($scope) ->
    $scope.tab = 'Live'
    $scope.receiver_data = {}
    $scope.dataPoints = {
                            "frequency": "Frequency(Hz)",
                            "signal": "Signal(mV)",
                            "noise": "Noise",
                            "s_n_ratio": "PS:N Ratio",
                            "inc": "Inclination",
                            "azm": "Azimuth",
                            "tf": "Tool Face",
                            "mag_dec": "Mag. Dec.",
                            "temperature": "Temp",
                            "gama": "Gamma",
                            "az": "Az",
                            "gravity": "Gravity",
                            "magf": "MagF",
                            "dipa": "Dip Angle",
                            "battery_number": "Battery",
                            "power": "Power",
                            "annular_pressure": "Annular Pressure",
                            "bore_pressure": "Bore Pressure",
                            "delta_mtf": "Delta MTF",
                            "grav_roll": "Gravity Roll",
                            "mag_roll": "Mag Roll",
                            "gamma_shock": "Gamma Shock (g)"
                        }

    $scope.changeTab = (tab) ->
      $scope.tab = tab

    $scope.$on $scope.channel, (evt, message) ->
      mergeData $scope.receiver_data, message

    $scope.getDate = (value) ->
      result = Date.parse(value)
      if isNaN(result)
        return ""
      result

    $scope.keyContains = (object) ->
      _.contains(Object.keys($scope.dataPoints), object)

    receiverFromChannel = (channel) ->
      switch channel
        when 'btr-receiver-updated' then 'BtrReceiverUpdate'
        when 'btr-control-receiver-updated' then 'BtrControlUpdate'
        when 'em-receiver-updated' then 'EmReceiverUpdate'
        else 'LeamReceiverUpdate' # leam-receiver-updated

    $scope.fetchUpdatesHistory = ->
      if $scope.receiver_data.job_id.value?
        type = receiverFromChannel($scope.channel)
        $http.get("/push/jobs/#{$scope.receiver_data.job_id.value}/recent_updates?type=" + type).then (response) ->
          $scope.history = response.data

    mergeData = (data, update) ->
      time = update.time
      if _.isEmpty data
        for own key, value of update
          data[key] = { name: key, value: value, time: time }
      else
        for own key, value of update
          if (value || value == 0) && (!_.isEmpty(data[key]) && data[key].value != value)
            data[key] = { name: key, value: value, time: time }
