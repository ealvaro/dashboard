Erdos.controller "ToolsController", ($scope, $http) ->
  $scope.show_tools = true
  $scope.show_memories = false
  $scope.subtitle = 'Tools'

  $scope.showTab = ( tab_name ) ->
    $scope.show_tools = ( tab_name == 'tools' )
    $scope.show_memories = ( tab_name == 'memories' )
    $scope.setSubtitle()

  $scope.showInit = (json) ->
    $scope.tool = JSON.parse(json)

  $scope.setSubtitle = ->
    if $scope.show_tools
      $scope.subtitle = 'Tools'
    else if $scope.show_memories
      $scope.subtitle = 'Memories'