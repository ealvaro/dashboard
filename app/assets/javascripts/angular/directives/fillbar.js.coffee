Erdos.directive "fillbar", () ->
  restrict: 'AEC'
  replace: true
  templateUrl: "fillbar.html"
  scope:
    attribute: "="
    staticColor: "="
  controller: ($scope) ->

    $scope.init = () ->
      setAttributeInt()
      setAttributePercent()
      setColorClass()
      setStyle()

    $scope.show = () ->
      if $scope.integer >= 0
        true
      else
        false

    setAttributeInt = () ->
      $scope.integer = parseInt( $scope.attribute )

    setAttributePercent = () ->
      if $scope.attribute
        $scope.percentage = $scope.attribute + "%"

    setColorClass = () ->
      $scope.color_class = if $scope.integer <= 75 or $scope.staticColor
                             "progress-bar progress-bar-success"
                           else
                             "progress-bar progress-bar-danger"

    setStyle = () ->
      $scope.style = if $scope.percentage
                       { width: $scope.percentage }
                     else
                       {}
