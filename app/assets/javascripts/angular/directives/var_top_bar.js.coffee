Erdos.directive "varTopBar", () ->
  restrict: 'E'
  templateUrl: "var_top_bar.html.erb"
  scope:
    heading: '='
    subtitle: '='