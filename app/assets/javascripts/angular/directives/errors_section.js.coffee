Erdos.directive "errorsSection", ->
  restrict: 'E'
  replace: true
  templateUrl: "errors_section.html.erb"
  scope:
    objects: "="
