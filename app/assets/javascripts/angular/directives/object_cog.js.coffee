 Erdos.directive "objectCog", ($http) ->
   restrict: 'AEC'
   replace: true
   templateUrl: "object_cog.html"
   scope:
     object: "="
     objects: "="
   controller: ($scope) ->
     $scope.showDetails = (object) ->
       object.details = true
