Erdos.directive "erdosReceiverPulseChart", ($interval) ->
  restrict: 'E'
  replace: true
  scope:
    channel: '='
    axisLabel: '@'
    title: '@'
    key: '@'
    showThreshold: '='
    showNegative: '='
    maxLength: '@'
    valueScale: '@'
    highDetail: '='
  templateUrl: "erdos_receiver_pulse_chart.html"
  controller: ($scope, $interval) ->
    $scope.points = []
    chart = undefined

    $scope.toggle = true;

    $scope.init = () ->
      $scope.drawChart()

    $scope.isCompressed = (pulseData) ->
      if jQuery.isArray(pulseData)
        #array is already decompressed
        pulseData
      else
        $scope.decompressPulseData(pulseData)

    $scope.decompressPulseData = (compressedData) ->
      decompressed = []
      values = compressedData.values
      sample_rate = compressedData.sample_rate
      time_stamp = compressedData.time_stamp
      milliseconds_per_sample = 1000 / sample_rate

      for value, index in values
        decompressed.push({
          "time_stamp": parseInt(time_stamp + milliseconds_per_sample * index),
          "value": value
        })
      decompressed

    $scope.$on $scope.channel, (evt, data) ->
      if not data.pulse_data?
        return

      pulseData = $scope.isCompressed(data.pulse_data)
      tmp = _.sortBy(pulseData, (point) ->
        parseInt(point.time_stamp)
      )

      if $scope.showThreshold
        chart.guides[0].toValue = data.low_pulse_threshold

      _.each tmp, (item) ->
        unless _.contains $scope.point, item
          $scope.points.push({
            date: parseInt(item.time_stamp)
            pulse_value: item.value * $scope.valueScale
          })

    $interval ->
      over = chart.dataProvider.length - parseInt($scope.maxLength)
      if over > 0
        chart.dataProvider.splice(0, over)

      if $scope.points.length > 0
        if $scope.points.length > 500
          maxIndex = 50
        else if $scope.points.length > 100
          maxIndex = 25
        else if $scope.points.length > 50
          maxIndex = 10
        else if $scope.points.length > 5
          maxIndex = 5
        else
          maxIndex = $scope.points.length

        for i in [0...maxIndex]
          chart.dataProvider.push($scope.points[i])
        $scope.points = $scope.points[maxIndex...$scope.points.length]

        maxRecord = _.max chart.dataProvider, (record) -> record.pulse_value
        scaledMax = maxRecord.pulse_value * 4 / 3
        scaledMax /= Math.max(parseFloat($scope.valueScale), 1)
        upToNearest10 = parseInt(scaledMax / 10) * 10 + 10
        valueAxis = chart.valueAxes[0]
        valueAxis.maximum = Math.max(valueAxis.maximum, upToNearest10)
        if $scope.showNegative
          valueAxis.minimum = Math.min(valueAxis.minimum, -upToNearest10)

        chart.validateData()

    , 250

    $scope.drawChart = () ->
      # SERIAL CHART
      chart = AmCharts.makeChart("#{$scope.channel}-#{$scope.title}", {
        "type": "serial",
        "theme": "light",
        "titles": [{
          "text": $scope.title,
          "size": 15
        }],
        "legend": {
          "align": "center",
          "equalWidths": false,
          "valueAlign": "left",
          "valueWidth": 0
        },
        "dataProvider": [],
        "valueAxes": [{
          "stackType": "none",
          "gridAlpha": 0.00,
          "position": "left",
          "title": $scope.axisLabel,
          "labelsEnabled": $scope.highDetail,
          "maximum": 1,
          "minimum": $scope.showNegative ? -1 : 0
        }],
        "graphs":
          if $scope.showNegative
            [{
              "balloonText": "Pulse [[value]]",
              "fillAlphas": 0.9,
              "lineAlpha": 0.9,
              "valueField": "pulse_value",
              "lineColor": "#FF7D13"
              "negativeBase": 0,
              "negativeLineColor": "#1E3D7D",
              "visibleInLegend": false
             }]
          else
            [{
              "balloonText": "Pulse [[value]]",
              "fillAlphas": 0.5,
              "lineAlpha": 0.5,
              "title": "Pulse",
              "valueField": "pulse_value",
             }]
        "guides":
          if $scope.showThreshold
            [{
              "lineColor": "#FF7D13"
              "lineAlpha": 0.5,
              "fillColor": "#FF7D13"
              "fillAlpha": 0.5,
              "value": 0,
              "toValue": 0
            }]
          else
            [{}]
        "plotAreaBorderAlpha": 0,
        "marginLeft": 0,
        "marginBottom": 0,
        "chartCursor": {
          "cursorAlpha": 0,
          "categoryBalloonEnabled": $scope.highDetail,
          "valueBalloonsEnabled": $scope.highDetail,
          "zoomable": false,
        },
        "categoryField": "date",
        "categoryAxis": {
          "equalSpacing":true,
          "parseDates": true,
          "startOnAxis": true,
          "axisColor": "#DADADA",
          "labelsEnabled": $scope.highDetail,
          "minPeriod": "mm"
        },
        "export": {
          "enabled": true
        }
      });

    times = ->
      if $scope.points.length > 0
        _.map($scope.points, (point) ->
          point.date.getTime())
