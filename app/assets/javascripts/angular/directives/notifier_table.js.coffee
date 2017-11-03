Erdos.directive "notifierTable", () ->
  restrict: 'E'
  replace: true
  templateUrl: "notifier_table.html.erb"
  controller: ($scope) ->
    $scope.selectedRig = (rig) ->
      $scope.rig.id == rig.id if $scope.rig? && rig?

    $scope.selectedGroup = (group) ->
      $scope.rigGroup.id == group.id if $scope.rigGroup? && group?

    $scope.selectedTemplate = (template) ->
      $scope.template.id == template.id if $scope.template? && template?
