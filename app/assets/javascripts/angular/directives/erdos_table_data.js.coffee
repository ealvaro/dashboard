Erdos.directive "erdosTableData", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "erdos_table_data.html.erb"
  scope:
    object: "="
    key: "="
    klass: "="
    url: "@"
  controller: ($scope) ->
    $scope.getDate = (event, attr) ->
      if event && event[attr]
        moment( Date.parse( event[attr] ) )
      else
        undefined

    $scope.getValue = ->
      nestedValue($scope.key)

    $scope.getUrl = ->
      nestedValue($scope.url)

    nestedValue = (key) ->
      keys = key.split(".")
      value = $scope.object
      for key in keys
        return value unless value
        value = value[key]
      value

    $scope.downloadAsset = (asset) ->
      $http({method: 'GET', url: '/push/assets/' + asset.id}).success (response) ->
        url = response.url
        window.open(url, "_parent")
