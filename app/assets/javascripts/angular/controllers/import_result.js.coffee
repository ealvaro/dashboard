Erdos.controller "ImportResultController", ($scope, $http) ->
  $scope.updates = []

  $scope.init = () ->
    refresh_updates()

  $scope.$on "import-updated", (evt, data) ->
    refresh_updates()

  refresh_updates = () ->
    $http({
      method: "GET"
      url: "/push/imports/#{$scope.importId}/import_updates"
      }).success (response) ->
        $scope.updates = response.imports

