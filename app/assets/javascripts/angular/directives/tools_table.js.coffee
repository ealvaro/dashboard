Erdos.directive "toolsTable", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "tools_table.html.erb"
  scope:
    filterType: '='
    searchText: '='
    objects: "="
    headers: '='
    cols: '='
    klass: '='
    loading: '='
    noActions: '='
    exportColumnKeys: '='
    currentUser: '='
    currentPage: '='
    pages: '='
    results: '='
  controller: ($scope) ->
    $scope.orderBy = ""
    $scope.reverse = false
    $scope.perPage = 25
    $scope.exportObjects = []
    $scope.results = ''

    $scope.setOrderBy = (key) ->
      key = key.replace('cache.', '')
      if $scope.orderBy == key
        $scope.reverse = !$scope.reverse
      else
        $scope.orderBy = key
        $scope.reverse = false
      fetchTools()

    $scope.exportable = ->
      $scope.exportColumnKeys && $scope.exportColumnKeys.length > 0

    $scope.export = () ->
      $scope.loading = true
      $http.post('v750/tools/csv', tool_type: $scope.filterType).then (response) ->
        results = []
        $scope.exportObjects = response.data
        for object in angular.copy($scope.exportObjects)
          jQuery.extend(object, object.cache) if object.cache
          return_obj = {}
          for key in  $scope.exportColumnKeys
            return_obj[key.replace(".", "_")] = getValue(key, object) || ""
          results.push(return_obj)
        $http( { method: 'POST', url: '/push/tools/to_csv', data: { objects_array: results } } ).success (response) ->
          window.open( response.file.url, "_parent" )
          $scope.loading = false

    getValue = (multi_key, object)->
      keys = multi_key.split(".")
      value = object
      for key in keys
        return value unless value
        value = value[key]
      value

    $scope.search = ->
      $scope.searchText = jQuery('#erdos-search-input').val()
      jQuery('#erdos-search-input').val('')
      $scope.currentPage = 1
      fetchTools()

    $scope.nextPage = ->
      $scope.currentPage++
      fetchTools()

    $scope.previousPage = ->
      $scope.currentPage--
      fetchTools()

    $scope.firstPage = ->
      $scope.currentPage = 1
      fetchTools()

    $scope.lastPage = ->
      $scope.currentPage = $scope.pages
      fetchTools()

    fetchTools = ->
      $scope.loading = true
      $http.get('/v750/tools?page=' + $scope.currentPage + '&reverse=' + $scope.reverse + '&tool_type=' + $scope.filterType + '&order=' + $scope.orderBy + '&search=' + $scope.searchText)
        .then (response) ->
          $scope.objects = response.data.tools
          $scope.pages = response.data.meta.pages
          $scope.results = response.data.meta.results
          $scope.loading = false
