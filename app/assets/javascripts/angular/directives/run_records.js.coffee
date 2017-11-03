Erdos.directive "runRecords", () ->
  restrict: 'E'
  replace: true
  templateUrl: "run_records.html.erb"
  scope:
    run: "="
  controller: ($scope) ->
    $scope.tools = $scope.run.tools
