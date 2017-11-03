Erdos.directive "gammaStripChart", () ->
  restrict: 'E'
  replace: true
  templateUrl: "gamma_strip_chart.html"
  controller: ($scope) ->
    chart = undefined

    $scope.init = () ->
      $scope.drawChart()

    $scope.$on 'gamma-update', (evt, data) ->
      datum = _.find chart.dataProvider, (d) -> data.id == d.id
      if datum?
        datum.gamma_count = data.count
      else
        datum =
          measured_depth: data.measured_depth
          gamma_count: data.count
          id: data.id
        sort = _.last(chart.dataProvider)?.measured_depth > data.measured_depth
        chart.dataProvider.push datum
        if sort
          chart.dataProvider = _.sortBy(chart.dataProvider, (d) ->
            d.measured_depth)

      chart.validateData()

    $scope.$on "gamma-refresh", (evt, data) ->
      if data.objects.length > 0
        chart.dataProvider = []

        tmp = _.sortBy(data.objects, (point) -> parseFloat(point.measured_depth))
        for point in tmp
          datum = {
            measured_depth: point.measured_depth
            gamma_count: point.count
            id: point.id
          }
          chart.dataProvider.push datum

        chart.validateData()

    $scope.drawChart = () ->
      chart = AmCharts.makeChart("stripChart", {
        "type": "xy",
        "theme": "light",
        "pathToImages": "//cdn.amcharts.com/lib/3/images/"
        "marginLeft": 68
        "marginTop": 26
        "marginBottom": 58
        "marginsUpdated": true
        "hideXScrollBar":true
        "labelsEnabled":true
        "chartCursor": {
          "cursorPosition": "mouse"
          "cursorColor": "#1f3f5b"
        }
        "chartScrollbar": {
          "dragIconHeight": 25
          "dragIconWidth": 18
        }
        "titles": [{
          "text": "Strip Chart"
          "size": 15
        }],
        "dataProvider": [],
        "graphs": [{
          "type": "line"
          "xField": "gamma_count"
          "yField": "measured_depth"
          "lineThickness": 2
          "lineColor": 'orange'#"#B96320"
          "bullet": "round"
          "bulletSize": 12
          "bulletAlpha": 0
          "bulletBorderAlpha": 0
          "bulletBorderThickness": 0
          "balloonText": "MD: [[measured_depth]]<br>Count: [[gamma_count]]"
          "title": "GAMMA GUESS"
        }],
        "valueAxes":[{
          "title": "Counts per second"
          "position": "bottom"
          "minimum": 0
          "maximum": 200
        },
        {
          "title": "Measured Depth (feet)"
          "reversed": true
          "position": "left"
        }]
       })
