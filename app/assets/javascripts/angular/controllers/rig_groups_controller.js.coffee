Erdos.controller "RigGroupsController", ($scope, $http) ->
  $scope.init  = (rig_group, editing, rigs) ->
    $scope.rigGroup = rig_group
    $scope.groupRigs = rigs
    $scope.editing = editing
    $scope.tab = 'Active'

  $scope.$watch 'tab', ->
    fetchRigs()

  $scope.changeTab = (tab) ->
    $scope.tab = tab

  fetchRigs = ->
    if $scope.tab == 'All'
      $http.get('/rigs').then (response) ->
        $scope.rigs = response.data
    else
      $http.get('/rigs/active').then (response) ->
        $scope.rigs = response.data

  $scope.add = (rig) ->
    ids = _.pluck($scope.groupRigs, 'id')
    unless rig.id in ids
      $scope.groupRigs.push rig

  $scope.remove = (rig) ->
    ids = _.pluck($scope.groupRigs, 'id')
    index = ids.indexOf(rig.id)
    $scope.groupRigs.splice(index, 1)

  $scope.submit = ->
    if $scope.editing == true
      $http.put('/rig_groups/' + $scope.rigGroup.id,
        rig_group: {name: $scope.rigGroup.name, rig_ids: _.pluck($scope.groupRigs, 'id')}
      )
    else
      $http.post('/rig_groups'
        rig_group: {name: $scope.rigGroup.name, rig_ids: _.pluck($scope.groupRigs, 'id')}
      )
    $scope.refreshTab()