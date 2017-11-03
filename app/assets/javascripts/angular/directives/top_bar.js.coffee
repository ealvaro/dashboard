Erdos.directive "topBar", () ->
  restrict: 'E'
  templateUrl: "top_bar.html.erb"
  controller: ($scope) ->
    $scope.init = (page, subtitle=null) ->
      $scope.heading = page
      $scope.subtitle = subtitle