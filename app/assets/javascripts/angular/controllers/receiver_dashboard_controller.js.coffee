Erdos.controller "ReceiverDashboardController", ($scope, $http, $timeout, Job, Pusher) ->
  $scope.channels = []
  $scope.receiver = {}

  $scope.init = (job, updatesJson) ->
    job = JSON.parse(job)
    $scope.jobId = job.id
    $scope.jobNumber = job.name
    $scope.client = job.client
    $scope.well = job.well
    $scope.rig = job.rig
    $scope.alerts = false
    fetchActiveJob()
    loadNotifications()

    $scope.$on "btr-receiver-updated", ->
      $scope.btrEnabled = true

    $scope.$on "btr-control-receiver-updated", ->
      $scope.btrControlEnabled = true

    $scope.$on "leam-receiver-updated", ->
      $scope.leamEnabled = true

    $scope.$on "em-receiver-updated", ->
      $scope.emEnabled = true

    $timeout ->
      json = JSON.parse updatesJson if updatesJson?

      btrJson = json["BtrReceiverUpdate"]
      if btrJson
        $scope.$root.$broadcast "btr-receiver-updated", btrJson
        $scope.$root.$broadcast "btr-receiver-pulse", btrJson

      btrCtrlJson = json["BtrControlUpdate"]
      if btrCtrlJson
        $scope.$root.$broadcast "btr-control-receiver-updated", btrCtrlJson
        $scope.$root.$broadcast "btr-control-receiver-pulse", btrCtrlJson

      emJson = json["EmReceiverUpdate"]
      if emJson
        $scope.$root.$broadcast "em-receiver-updated", emJson
        $scope.$root.$broadcast "em-receiver-pulse", emJson
        $scope.$root.$broadcast "em-receiver-fft", emJson

      loggerJson = json["LoggerUpdate"]
      if loggerJson
        $scope.$root.$broadcast "logger-updated", loggerJson

      leamJson = json["LeamReceiverUpdate"]
      if leamJson
        $scope.$root.$broadcast "leam-receiver-updated", leamJson
        $scope.$root.$broadcast "leam-receiver-pulse", leamJson
    , 500

  $scope.test = () ->
    $http({
      method: "POST"
      url: if $scope.test_btr then "/v710/jobs/#{$scope.jobId}/test_receiver_btr" else
           "/v710/jobs/#{$scope.jobId}/test_receiver_leam"
    }).success (response) ->
      true

  interval = null

  $scope.startTestInterval = () ->
    $scope.testing = true
    $scope.test()
    interval = setInterval($scope.test, 3000)

  $scope.stopTestInterval = () ->
    $scope.testing = false
    clearInterval(interval)

  $scope.testLogger = () ->
    $http({
      method: "POST"
      url: "/v710/jobs/#{$scope.jobId}/test_logger"
    }).success (response) ->
      true

  $scope.startTestLoggingInterval = () ->
    $scope.testingLogger = true
    $scope.testLogger()
    interval = setInterval($scope.testLogger, 3000)

  $scope.stopTestLoggingInterval = () ->
    $scope.testingLogger = false
    clearInterval(interval)

  $scope.testGamma = () ->
    $http({
      method: "POST"
      url: "/v730/gammas/test_gamma/?job_id=#{$scope.jobId}"
    }).success (response) ->
      true

  $scope.$on "active-job-data", (evt, data) ->
    if $scope.job && data.job && $scope.job.name.toUpperCase() == data.job.toUpperCase()
      data.details = true if $scope.job.details
      data.job_id = $scope.job.id
      data.rig = data.rig_name.toUpperCase() if data.rig_name?
      data.well = data.well.toUpperCase() if data.well?

      mergeData $scope.job, data
      if not $scope.job.last_updates?[data.type]?
        $scope.job.last_updates[data.type] = {}
      mergeData $scope.job.last_updates[data.type], data

  fetchActiveJob = () ->
    $http.get('/push/jobs/active/' + $scope.jobId)
      .then (response) ->
        $scope.job = response.data

  mergeData = (original, data) ->
    new_data = {}
    for own key,value of data
      if value
        new_data[key] = value
    jQuery.extend original, new_data

  loadNotifications = ->
    $http.get("/v770/notifications",
      params:
        active: $scope.status == "Active"
        job_number: $scope.jobNumber
    ).success (notifications) ->
      if notifications.length > 0
        $scope.alerts = true
      else
        $scope.alerts = false
    $scope.loadRequested = false

  $scope.loadRequested = false
  requestNotificationsIfNot = ->
    if not $scope.loadRequested
      $timeout loadNotifications, 1000
      $scope.loadRequested = true

  Pusher.subscribe "UpdateNotification", "create", (message) ->
    if $scope.jobNumber.toLowerCase() == message["job"]?.toLowerCase()
      requestNotificationsIfNot()

  Pusher.subscribe "UpdateNotification", "update", (message) ->
    if $scope.jobNumber.toLowerCase() == message["job"]?.toLowerCase()
      requestNotificationsIfNot()
