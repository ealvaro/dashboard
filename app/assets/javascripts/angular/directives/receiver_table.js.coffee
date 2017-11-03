Erdos.directive "erdosReceiverTable", ($http) ->
  restrict: 'E'
  replace: true
  scope:
    channel: '='
  templateUrl: "erdos_receiver_table.html"
  controller: ($scope) ->
    $scope.tab = 'Live'
    $scope.receiver_data = {}
    $scope.dataPoints = {
                            "pump_on_time": "Pumps On",
                            "pump_off_time": "Pumps Off",
                            "pump_total_time": "Pumps Total",
                            "pump_pressure": "Pumps Pressure",
                            "inc": "Inclination",
                            "azm": "Azimuth",
                            "tf": "Tool Face",
                            "gama": "Gamma",
                            "temperature": "Temp",
                            "decode_percentage": "Decode Avg",
                            "az": "Az",
                            "gravity": "Gravity",
                            "magf": "MagF",
                            "dipa": "Dip Angle",
                            "batv": "BatV",
                            "average_quality": "Avg Quality"
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

    mergeData = (current_data, update) ->
      time = update.time
      for own key, value of update
        if value?
          if !current_data[key]?
            current_data[key] = { value: value, time: time }
          else if (current_data[key].value != value)
            current_data[key] = { value: value, time: time }