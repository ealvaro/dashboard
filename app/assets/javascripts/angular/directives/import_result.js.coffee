Erdos.directive "erdosImportResult", () ->
  restrict: 'A'
  templateUrl: "erdos_import_result.html.erb"
  controller: ($scope) ->
    $scope.log_level = "ERROR"
