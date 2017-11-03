Erdos.directive "truckRequestsTable", () ->
  restrict: 'E'
  templateUrl: "truck_requests_table.html.erb"
  controller: ($scope) ->
    $scope.init = ->
      $scope.getIndex()

    $scope.mark = (id, status) ->
      notes = window.prompt("Please enter notes:", "Updated from Portal");
      if notes
        $scope.putUpdate(id, status, notes)