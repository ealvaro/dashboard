Erdos.directive "receivers", (User, $filter, Receiver, $http) ->
  restrict: 'AEC'
  replace: true
  templateUrl: "receivers.html.erb"
  scope:
    objects: '='
    loading: '='
  controller: ($scope) ->
    $scope.showJobs = []
    $scope.showClients = []
    $scope.showRigs = []
    $scope.orderBy = ""
    $scope.reverse = false
    $scope.currentUser = User.currentUser()
    $scope.currentUser.$promise.then (user) ->
      $scope.headers = user.settings.headers.receivers.headers
      $scope.currentUser = user
      $scope.follows = user.follows

    $scope.objects.$promise.then ->
      for object in $scope.objects
        # load up historical data
        for updateType in ["BtrReceiverUpdate", "BtrControlUpdate", "EmReceiverUpdate", "LeamReceiverUpdate", "LoggerUpdate"]
          if object.last_updates[updateType]
            extend_no_null(object, object.last_updates[updateType])
      recalculateFilters()

    $scope.$on "active-jobs-updated", ->
      fetchActiveJobs()

    $scope.$on "active-job-data", (evt, data) ->
      index = 0
      found = false
      for object in $scope.objects
        if object.job && data.job && object.job.toLowerCase() == data.job.toLowerCase()
          data.details = true if object.details
          data.time_stamp = new Date(Date.parse(data.time_stamp))
          data.job_show_url = object.job_show_url
          data.run_show_url = object.run_show_url
          data.active_url = object.active_url

          found = true
          break
        index += 1

      if found
        data.name = $scope.objects[index].name
        extend_object($scope.objects[index], data)
      recalculateFilters()

    extend_no_null = (object, data) ->
      new_data = {}
      for own key,value of data
        if key != 'id' && value?
          new_data[key] = value

      jQuery.extend(object, new_data)

    extend_object = (object, data) ->
      if data?
        object.last_updates[data.type] = data
        extend_no_null(object, data)

    $scope.headers = []

    $scope.toggleJobFilter = (filter) ->
      if filter == "Subscribed"
        $scope.showJobs = $scope.follows
      else if filter == "Active"
        fetchActiveJobs().then ->
          $scope.showJobs = _.pluck($scope.objects, 'job')
      else if filter == "Recent"
        fetchRecentJobs().then ->
          $scope.showJobs = _.pluck($scope.objects, 'job')
      else
        $scope.showJobs = [filter]

      $scope.$broadcast "job-number-update", {"jobNumbers": $scope.showJobs}
      setFilterText('job', filter)
      recalculateFilteredObjects()

    setFilterText = (type, filter) ->
      if type == 'job'
        if filter == 'Subscribed'
          $scope.filterText = "Subscribed"
        else if $scope.showJobs.length == 1
          $scope.filterText = $scope.showJobs[0]
        else
          $scope.filterText = "Job"

    $scope.toggleClientFilter = (name) ->
      index = $scope.showClients.indexOf(name)
      if index == -1
        $scope.showClients.push name
      else
        $scope.showClients.splice(index, 1)
      recalculateFilteredObjects()

    $scope.toggleRigFilter = (name) ->
      index = $scope.showRigs.indexOf(name)
      if index == -1
        $scope.showRigs.push name
      else
        $scope.showRigs.splice(index, 1)
      recalculateFilteredObjects()

    $scope.getFilteredObjects = ->
      recalculateFilteredObjects()

    recalculateFilters = ->
      $scope.jobs = ["Active", "Recent", "Subscribed"]
      $scope.clients = []
      $scope.rigs = []
      for object in $scope.objects
        if object.job && $scope.jobs.indexOf(object.job) == -1
          $scope.jobs.push object.job
        if object.client && $scope.clients.indexOf(object.client) == -1
          $scope.clients.push object.client
        if object.rig && $scope.rigs.indexOf(object.rig) == -1
          $scope.rigs.push object.rig
      recalculateFilteredObjects()

    recalculateFilteredObjects = ->
      $scope.filtered = $filter('showJob')($scope.objects, $scope.showJobs, $scope.showClients, $scope.showRigs)

    fetchActiveJobs = ->
      Receiver.query().$promise.then (data) ->
        $scope.objects = data
        recalculateFilters()

    fetchRecentJobs = ->
      $http.get('v730/jobs/recent').then (response) ->
        $scope.objects = response.data
        recalculateFilters()