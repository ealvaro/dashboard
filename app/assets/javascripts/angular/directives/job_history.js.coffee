Erdos.directive "jobHistory", ($http) ->
  restrict: 'E'
  replace: true
  scope:
    job: '='
  templateUrl: "job_history.html.erb"
  controller: ($scope) ->
    $scope.wellName = ->
      result = ""
      if $scope.job.runs
        for run in $scope.job.runs
          if run.well
            result = run.well.name
      result

    $scope.rigName = ->
      result = ""
      if $scope.job.runs
        for run in $scope.job.runs
          if run.rig
            result = run.rig.name
      result
