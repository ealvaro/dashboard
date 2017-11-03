Erdos.directive "paging", () ->
  templateUrl: "paging.html"
  scope:
    currentPage: "="
    paging: "=erPaging"
    pagingChange: "="
  controller: ($scope) ->
    $scope.$watch "paging", () ->
      if $scope.paging?
        $scope.pages = [1..$scope.paging.number_of_pages]

    $scope.$watch "currentPage", () ->
      $scope.pagingChange()

    $scope.setPage = (newPage) ->
      newPage = 1 if newPage < 1
      if newPage > $scope.paging.number_of_pages
        newPage = $scope.paging.number_of_pages
      $scope.currentPage = newPage
