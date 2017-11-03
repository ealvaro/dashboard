Erdos.directive "histogramChart", (Pusher) ->
  restrict: 'E'
  templateUrl: "histogram_chart.html.erb"
  controller: ($scope) ->
    $scope.init = ->
      drawChart()

    valueAxisTitle = ->
      if $scope.tab == 'Shock' then "Counts" else "Hours"

    categoryAxisTitle = ->
      if $scope.tab == 'Temperature' then m = "C" else m = "G"
      $scope.tab + " Bins in " + m

    filterKeys = (keys) ->
      omit = _.uniq $scope.data.omit.concat(_.pluck($scope.data.legend, 'title'))
      for type in omit
        index = keys.indexOf(type)
        keys.splice(index, 1) if index != -1

    extractKeys = (array) ->
      temp = []
      for obj in array
        keys = _.keys(obj)
        for key in keys
          temp.push(key) unless _.contains(temp, key)
      temp

    graphKeys = (data) ->
      keys = extractKeys(data)
      filterKeys(keys)
      keys.sort()

    colorFromLegend = (type) ->
      _.findWhere($scope.data.legend, { title: type }).color

    filterType = (type) ->
      if type.indexOf(' ') != -1
        type.split(' ')
      type

    newStack = (previous, current) ->
      previous != current

    graphsFilter = ->
      temp = []
      keys = graphKeys($scope.filtered[$scope.tab])
      if $scope.tab == 'Temperature'
        for key in keys
          temp.push({
            "balloonText": "Total: [[total]]\n[[title]]: [[value]]",
            "fillAlphas": 0.6,
            "fillColors": "#3498db",
            "lineColor": "#3498db",
            "title": key,
            "type": "column",
            "valueField": key
            })
      else
        previous = ""
        for key in keys
          subtype = $scope.getSubtype(key)
          job_number = $scope.getJobNumber(key)
          temp.push({
            "balloonText": "Total: [[#{subtype}]]\n#{job_number}: [[value]]",
            "fillAlphas": 0.6,
            "fillColors": colorFromLegend(subtype),
            "lineColor": colorFromLegend(subtype),
            "newStack": newStack(previous, subtype),
            "title": subtype,
            "type": "column",
            "valueField": key
          })
          previous = subtype
        key = "Average"
        temp.push({
            "balloonText": "[[title]]: [[value]]",
            "fillAlphas": 1,
            "fillColors": colorFromLegend(key),
            "lineColor": colorFromLegend(key),
            "newStack": newStack(previous, key),
            "title": $scope.humanizeLabel(key),
            "type": "column",
            "valueField": key
          })
      temp

    $scope.$watch 'tab', ->
      drawChart()

    $scope.$watch 'filtered', ->
      drawChart()

    drawChart = ->
      chart = AmCharts.makeChart("histogramChart", {
        "type": "serial",
        "categoryField": "Range",
        "startDuration": 1,
        "categoryAxis": {
          "gridPosition": "start",
          "title": categoryAxisTitle()
        },
        "trendLines": [],
        "graphs": graphsFilter(),
        "guides": [],
        "valueAxes": [
          {
            "id": "ValueAxis-1",
            "stackType": "regular",
            "title": valueAxisTitle()
          }
        ],
        "allLabels": [],
        "balloon": {},
        "legend": {
          "enabled": $scope.tab != 'Temperature',
          "useGraphSettings": false,
          "data": $scope.data.legend
        },
        "titles": [
          {
            "id": "Title-1",
            "size": 15,
            "text": $scope.tab
          }
        ],
        "dataProvider": $scope.filtered[$scope.tab] || []
      })