Erdos.directive "paginatedSearch", () ->
  restrict: 'E'
  replace: true
  templateUrl: "paginated_search.html.erb"
  scope:
    searchText: '='
