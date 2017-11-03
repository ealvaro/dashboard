Erdos.directive "templateForm", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "template_form.html.erb"
  controller: ($scope) ->
    $scope.init = ->
      $scope.jobTab = 'Active'
      unless $scope.editTemp
        fetchNew()
      $scope.jobPage = 1
      $scope.jobPages = 1

    fetchNew = ->
      $http.get('/templates/new').then (response) ->
        $scope.template = response.data

    fetchJobs = ->
      $scope.loading = true
      if $scope.jobTab == 'All'
        fetchAllJobs()
      else
        fetchActiveJobs()

    fetchActiveJobs = ->
      $http.get('/v710/jobs/active').then (response) ->
        if response.data.length > 0
          $scope.jobs = response.data
        else
          $scope.jobTab = 'All'
        $scope.loading = false

    fetchAllJobs = ->
      $http.get('/push/jobs', params: { page: $scope.jobPage }).then (response) ->
        $scope.jobs = response.data.jobs
        $scope.jobPages = response.data.meta.pages
        $scope.loading = false

    $scope.changeJob = (job) ->
      $scope.template.job = job
      $scope.template.job_id = job.id

    $scope.submit = ->
      if $scope.editTemp
        $http.put('templates/' + $scope.template.id, template: $scope.template).then ->
      else
        $http.post('templates', template: $scope.template).then ->
      $scope.refreshTab()

    $scope.changeJobPage = (page) ->
      $scope.jobPage = page
      fetchJobs()

    $scope.changeJobTab = (tab) ->
      $scope.jobPage = 1
      $scope.jobPages = 1
      $scope.jobTab = tab

    $scope.selectedJob = (job) ->
      $scope.template.job == job

    $scope.$watch 'jobTab', ->
      fetchJobs()