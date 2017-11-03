Erdos.controller "JobsController", ($scope, $http) ->
  $scope.init = ->
    $scope.page = 1
    fetchJobs()
    fetchClients()

  fetchJobs = ->
    $scope.loading = true
    $http.get('push/jobs', params: { page: $scope.page }).then (response) ->
      $scope.jobs = response.data.jobs
      $scope.pages = response.data.meta.pages
      $scope.loading = false

  fetchClients = ->
    $http.get('push/clients', params: { basic: true }).then (response) ->
      $scope.clients = response.data

  $scope.searchJobs = (keyword) ->
    $scope.page = 1
    $scope.loading = true
    $http.get('push/jobs/search_all', params: { keywords: keyword }).then (response) ->
      $scope.jobs = response.data.jobs
      $scope.pages = response.data.meta.pages
      $scope.loading = false

  $scope.newJob = ->
    $scope.cancel()
    $scope.new = true

  $scope.editJob = (job) ->
    $scope.cancel()
    $scope.editing = job.id

  $scope.cancel = ->
    $scope.editing = {}
    $scope.new = false

  $scope.saveJob = (job) ->
    if $scope.new
      $http.post('push/jobs/', { job: { name: job.name, client_id: job.client_id } }).then (response) ->
        $scope.cancel()
        fetchJobs()
        fetchClients()
    else
      $http.put('push/jobs/' + job.id, { job: { name: job.name, client_id: job.client_id } }).then (response) ->
        $scope.cancel()
        fetchJobs()
        fetchClients()

  $scope.deleteJob = (job) ->
    $http.delete('push/jobs/' + job.id).then (response) ->
      fetchJobs()
      fetchClients()

  $scope.nextPage = ->
    $scope.page += 1
    fetchJobs()

  $scope.previousPage = ->
    $scope.page -= 1
    fetchJobs()

  $scope.changeActivity = (job) ->
    $http.get("/push/jobs/#{job.id}/#{activityUrl(job)}").then ->
      fetchJobs()

  activityUrl = (job) ->
    if job.activity == "Inactive" then "mark_active" else "mark_inactive"