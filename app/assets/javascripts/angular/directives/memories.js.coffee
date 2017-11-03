Erdos.directive "memories", ($http) ->
  restrict: 'AEC'
  replace: true
  templateUrl: "memories.html.erb"
  controller: ($scope) ->
    $scope.events = []
    $scope.memory_only = true

    $scope.fetchMemories = ->
      $http.get('/v750/recent_memories')
        .then (response) ->
          $scope.events = response.data.memories
          $scope.pages = response.data.meta.pages
          $scope.results = response.data.meta.results
          $scope.loading = false
