Erdos.directive "erdosTable", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "erdos_table.html.erb"
  scope:
    searchText: '='
    objects: "="
    headers: '='
    cols: '='
    klass: '='
    loading: '='
    noActions: '='
    exportColumnKeys: '='
    currentUser: '='
    follows: '='
  controller: ($scope) ->
    $scope.order_by = ""
    $scope.reverse = false
    $scope.currentPage = 1
    $scope.perPage = 30
    $scope.exportObjects = []
    $scope.totalItems = 120

    $scope.setOrderBy = (key) ->
      if $scope.orderBy = key
        $scope.reverse = !$scope.reverse
      else
        $scope.orderBy = key
        $scope.reverse = false

    $scope.exportable = ->
      $scope.exportColumnKeys && $scope.exportColumnKeys.length > 0

    $scope.export = () ->
      prepedObjects = prepareExportObjects()
      $http( { method: 'POST', url: '/push/tools/to_csv', data: { objects_array: prepedObjects } } ).success (response) ->
        window.open( response.file.url, "_parent" )

    prepareExportObjects = ->
      results = []
      for object in angular.copy($scope.exportObjects)
        jQuery.extend(object, object.cache) if object.cache
        return_obj = {}
        for key in  $scope.exportColumnKeys
          return_obj[key.replace(".", "_")] = getValue(key, object) || ""
        results.push(return_obj)
      results

    getValue = (multi_key, object)->
      keys = multi_key.split(".")
      value = object
      for key in keys
        return value unless value
        value = value[key]
      value
