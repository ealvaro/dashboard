Erdos.directive "erdosImportPusherListener", () ->
  restrict: 'A'
  scope:
    importId: "@"
  controller: ($scope, Pusher, $rootScope) ->
    Pusher.subscribe "import-#{$scope.importId}", 'update', (message) ->
      $rootScope.import_message = message
      $rootScope.$broadcast "import-updated", message

    Pusher.subscribe "import-#{$scope.importId}", 'pulse', (message) ->
      $rootScope.$broadcast "importer-pulse", message
