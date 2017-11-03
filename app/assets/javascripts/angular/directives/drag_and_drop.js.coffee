Erdos.directive "dragAndDrop", () ->
  restrict: 'AEC'
  replace: true
  templateUrl: "drag_and_drop.html"
  scope:
    included: '='
    excluded: '='
  controller: ($scope) ->
    $scope.$watchCollection 'included', (array)->
      if $scope.included
        for obj in $scope.included
          index = 0
          for item in $scope.excluded
            if obj.id == item.id
              return $scope.excluded.splice(index,1)
            else
              index += 1


    $scope.$watchCollection 'excluded', (array)->
      if $scope.excluded
        for obj in $scope.excluded
          index = 0
          for item in $scope.included
            if obj.id == item.id
              return $scope.included.splice(index,1)
            else
              index += 1
