Erdos.controller "ReceiversController", ($scope, $http, Client, Receiver) ->
  $scope.objects = []
  $scope.loading = true
  $scope.tab = 'Active'
  $scope.clients = []
  $scope.failedSearch = false

  $scope.objects = Receiver.query()
  $scope.objects.$promise.then ->
    $scope.loading = false

  $scope.$watch 'tab', ->
    if $scope.tab == 'All' && $scope.clients.length == 0
      $scope.loadingJobs = true
      $http({method: "GET", url: '/push/clients', params: {shallow: true}}).success (clients) ->
        $scope.clients = clients

  $scope.change = (value) ->
    if value && value.id
      Client.get({id: value.id}).$promise.then (client) ->
        $scope.jobs = client.jobs

  $scope.changeJob = (value) ->
    if value && value.id
      $scope.job = value

  $scope.search = (jobNumber)->
    $http(method: 'GET', url: '/push/jobs/search', params:{job_number: jobNumber}).success (response) ->
      if (response && Object.keys(response).length > 0)
        $scope.failedSearch = false
        $scope.job = response
      else
        $scope.failedSearch = true