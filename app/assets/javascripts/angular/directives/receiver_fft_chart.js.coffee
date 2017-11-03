Erdos.directive "erdosReceiverFftChart", ->
  restrict: 'E'
  scope:
    channel: '='
  templateUrl: "erdos_receiver_fft_chart.html"
  controller: ($scope) ->
    $scope.points = []
    chart = undefined

    $scope.init = () ->
      $scope.drawChart()

    MIN_FREQ = 0
    MAX_FREQ = 60
    STEP_FREQ = 0.5

    fillZeros = (fromFreq, toFreq) ->
      while fromFreq < toFreq and fromFreq <= MAX_FREQ
        chart.dataProvider.push
          freq: fromFreq
          ampl: 0.0
        fromFreq += STEP_FREQ
      fromFreq

    $scope.$on $scope.channel, (evt, data) ->
      if not data.fft? or data.fft.length == 0
        return

      chart.dataProvider = []
      lastFreq = 0.0

      # invariant: data.fft is sorted by freq
      _.each data.fft, (item) ->
        freq = parseFloat(item.freq)
        if freq >= MIN_FREQ and freq <= MAX_FREQ
          lastFreq = fillZeros(lastFreq, freq)
          chart.dataProvider.push
            freq: freq
            ampl: parseFloat(item.ampl)

      fillZeros(chart.dataProvider[chart.dataProvider.length - 1].freq, MAX_FREQ + STEP_FREQ)

      maxRecord = _.max chart.dataProvider, (record) -> record.ampl
      upToNearest10 = parseInt(maxRecord.ampl / 10) * 10 + 10
      valueAxis = chart.valueAxes[0]
      valueAxis.maximum = Math.max(valueAxis.maximum, upToNearest10)
      chart.validateData()

    $scope.drawChart = () ->
      # SERIAL CHART
      chart = AmCharts.makeChart("fftChart", {
        "type": "serial",
        "categoryField": "freq",
        "theme": "light",
        "labelsEnabled": false,
        "categoryAxis": {
          "labelsEnabled": true,
          #"autoGridCount": false,
          #"gridCount": 0
        },
        "chartCursor": {
          "enabled": true,
          "zoomable": false
        },
        "chartScrollbar": {
          "enabled": false
        },
        "trendLines": [],
        "graphs": [
          {
            "fillAlphas": 1.0,
            "fillColors": "#1E3D7D",
            "id": "AmGraph-1",
            "legendValueText": "",
            "lineThickness": 0,
            "markerType": "square",
            "title": "graph 1",
            "type": "column",
            "valueField": "ampl"
          }
        ],
        "guides": [],
        "valueAxes": [
          {
            "id": "ValueAxis-1",
            "title": "",
            "maximum": 1,
          }
        ],
        "allLabels": [],
        "balloon": {},
        "titles": [
          {
            "id": "Title-1",
            "size": 15,
            "text": "FFT"
          }
        ],
        "dataProvider": []
      });

      # WRITE
      if $scope.channel.indexOf("em") > -1
        $(".fftChart")[0].id = "fftChartEm"
        chart.write "fftChartEm"
