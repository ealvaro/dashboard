Erdos.controller "ApplicationController", ($scope, $timeout) ->
  $scope.init = (id) ->
    $scope.userId = id
    $scope.expanded = false

  $scope.expand = ->
    if $scope.expanded
      $scope.expanded = false
    else
      $scope.expanded = true

  $scope.expandForMenu = ->
    # after clicking off the menu, the auto-expansion should go away
    $scope.expand()
    $timeout ->
      $('html').click ->
        $('html').unbind('click')
        $timeout ->
          if $scope.expanded
            $scope.expand()
