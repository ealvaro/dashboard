Erdos.directive "recentEventsTable", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "recent_events_table.html.erb"
  scope:
    objects: "="
    headers: '='
    cols: '='
    klass: '='
    loading: '='
    noActions: '='
    exportColumnKeys: '='
    uid: '='
    currentUser: '='
    pages: '='
    results: '='
    searchText: '='
    type: '='
  controller: ($scope) ->
    $scope.orderBy = ""
    $scope.reverse = false
    $scope.currentPage = 1
    $scope.perPage = 25
    $scope.exportObjects = []

    $scope.setOrderBy = (key) ->
      key = key.replace('cache.', '')
      if $scope.orderBy == key
        $scope.reverse = !$scope.reverse
      else
        $scope.orderBy = key
        $scope.reverse = false
      fetchMemories()

    $scope.exportable = ->
      $scope.exportColumnKeys && $scope.exportColumnKeys.length > 0

    $scope.export = () ->
      $scope.loading = true
      $http.post('v750/recent_memories/csv', type: $scope.type).then (response) ->
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
      fetchMemories()

    $scope.nextPage = ->
      $scope.currentPage++
      fetchMemories()

    $scope.previousPage = ->
      $scope.currentPage--
      fetchMemories()

    $scope.firstPage = ->
      $scope.currentPage = 1
      fetchMemories()

    $scope.lastPage = ->
      $scope.currentPage = $scope.pages
      fetchMemories()

    fetchMemories = ->
      $scope.loading = true
      $http.get('/v750/recent_memories?page=' + $scope.currentPage +
                                        '&reverse=' + $scope.reverse +
                                        '&order=' + $scope.orderBy +
                                        '&type=' + $scope.type +
                                        '&search=' + $scope.searchText)
        .then (response) ->
          $scope.objects = response.data.memories
          $scope.pages = response.data.meta.pages
          $scope.results = response.data.meta.results
          $scope.loading = false
