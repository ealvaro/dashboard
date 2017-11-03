Erdos.directive "notifierGroup", ->
  restrict: 'E'
  replace: true
  scope:
    group: '='
    options: '='
    uniquify: '&'
    showRequired: '&'
  templateUrl: "notifier_group.html"
  controller: ($scope) ->
    $scope.name = "match" + $scope.uniquify()()
    $scope.name = "boolean_op" + $scope.uniquify()()

    $scope.showRequiredText = () ->
      $scope.showRequired() ($scope.name)
