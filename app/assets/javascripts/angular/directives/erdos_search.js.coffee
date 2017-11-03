Erdos.directive "erdosSearch", () ->
  restrict: 'E'
  replace: true
  templateUrl: "erdos_search.html.erb"
  scope:
    searchText: '='