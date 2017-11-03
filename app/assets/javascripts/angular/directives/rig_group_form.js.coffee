Erdos.directive "rigGroupForm", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "rig_group_form.html.erb"
  controller: ($scope) ->
    $scope.groupRigs = $scope.rigGroup.rigs || []
    $scope.tab = 'Active'

    $scope.$watch 'tab', ->
      fetchRigs()

    $scope.add = (rig) ->
      ids = _.pluck($scope.groupRigs, 'id')
      unless rig.id in ids
        $scope.groupRigs.push rig

    $scope.remove = (rig) ->
      ids = _.pluck($scope.groupRigs, 'id')
      index = ids.indexOf(rig.id)
      $scope.groupRigs.splice(index, 1)

    $scope.submit = ->
      if $scope.editGroup == true
        $http.put('/rig_groups/' + $scope.rigGroup.id,
          rig_group: {name: $scope.rigGroup.name, rig_ids: _.pluck($scope.groupRigs, 'id')}
        )
      else
        $http.post('/rig_groups'
          rig_group: {name: $scope.rigGroup.name, rig_ids: _.pluck($scope.groupRigs, 'id')}
        )
      $scope.refreshTab()
