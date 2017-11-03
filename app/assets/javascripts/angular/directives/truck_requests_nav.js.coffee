Erdos.directive "truckRequestsNav", () ->
  restrict: 'E'
  templateUrl: "truck_requests_nav.html.erb"
  controller: ($scope) ->
    $scope.changeTab = (tab) ->
      $scope.tab = tab
      $scope.getIndex(tab == 'serviced')
      $scope.keyword = ""