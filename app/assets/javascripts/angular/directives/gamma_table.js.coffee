Erdos.directive "gammaTable", ->
  restrict: 'E'
  replace: true
  scope:
    jobId: '='
  templateUrl: "gamma_table.html"
  controller: ($scope, $element) ->
    $scope.objects = []

    $scope.$on "gamma-loading", (evt) ->
      $scope.loading = true

    $scope.$on "gamma-refresh", (evt, data) ->
      $scope.objects = data.objects
      $scope.loading = false

    $scope.$on 'gamma-update', (evt, data) ->
      index = _.sortedIndex $scope.objects, data, (d) ->
        d['measured_depth']
      found = $scope.objects[index]
      if found? and found.measured_depth == data.measured_depth
        found.count = data.count
        found.measured_depth = data.measured_depth
      else
        copy = jQuery.extend({}, data)
        $scope.objects.splice(index, 0, copy)
