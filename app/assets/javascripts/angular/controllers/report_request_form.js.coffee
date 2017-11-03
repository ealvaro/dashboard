Erdos.controller "ReportRequestFormController", ($scope, $http) ->
  $scope.loading = true
  $scope.job = ''
  $scope.data = {}

  $scope.updateJob = (job) ->
    getJobData(job)

  getJobData = (jobNumber) ->
    $http.get('/v750/report_requests/report_data?job=' + $scope.job)
      .then (response) ->
        $scope.data = response.data