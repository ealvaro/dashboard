Erdos.directive "notificationTable", ($http, $timeout, Pusher, User) ->
  restrict: 'E'
  replace: true
  scope:
    status: '='
    jobNumbers: '='
    headers: '='
  templateUrl: "notification_table.html.erb"
  controller: ($scope, $http, Pusher, User) ->
    $scope.page = 1
    $scope.pages = 1
    $scope.objects = []
    $scope.selectedNotifs = []

    $scope.$watch 'status', ->
      $scope.page = 1
      reloadNotifications()

    $scope.$on "job-number-update", (evt, data) ->
      $scope.jobNumbers = data.jobNumbers
      reloadNotifications()

    $scope.selectNotif = (id) ->
      if $scope.selectedNotifs.indexOf( id ) == -1
        $scope.selectedNotifs.push id
      else
        $scope.selectedNotifs.splice($scope.selectedNotifs.indexOf(id),1)

    $scope.deleteNotifs = (event, objects, status) ->
      event.preventDefault()
      $http({method: "PUT", url: '/v750/notifications/complete/', data: {notification_ids: objects, status: status}})

    $scope.ding = ->
      # TODO: modernize this
      if navigator.appName == 'Microsoft Internet Explorer'
        element = document.createElement('BGSOUND')
        element.src = '/alert.wav'
        element.loop = 1
        document.body.appendChild(element)
        document.body.removeChild(element)
      else
        element = document.createElement('AUDIO')
        source = document.createElement('SOURCE')
        source.type = 'audio/mp3'
        source.src = '/alert.mp3'
        element.appendChild(source)
        element.play()

    reloadNotifications = ->
      $scope.loading = true
      $scope.loadRequested = false
      $http.get("/v770/notifications",
        params:
          following: $scope.status == "Following"
          all: $scope.status == "All"
          completed: $scope.status == "Resolved"
          active: $scope.status == "Active"
          "job_numbers[]": $scope.jobNumbers
          keyword: jQuery('#alert-search-content').val()
          page: $scope.page
      ).then (response) ->
        $scope.objects = response.data.notifications
        $scope.selectedNotifs = []
        $scope.loading = false
        $scope.pages = response.data.meta.pages
        if $scope.newNotification && $scope.objects.length > 0
          $scope.ding()
          $scope.newNotification = false

    reloadNotifications().then ->
      if $scope.objects.length == 0
        $scope.status = "Active"
        reloadNotifications()

    $scope.loadRequested = false
    requestNotificationsIfNot = ->
      if not $scope.loadRequested
        $timeout reloadNotifications, 1000
        $scope.loadRequested = true

    jobMatch = (job) ->
      return true if not job?
      return true if _.isEmpty($scope.jobNumbers)
      job.toLowerCase() in _.map($scope.jobNumbers, (job) -> job.toLowerCase())

    Pusher.subscribe "UpdateNotification", "create", (message) ->
      $scope.newNotification |= jobMatch message.job
      requestNotificationsIfNot() if $scope.newNotification

    Pusher.subscribe "UpdateNotification", "update", (message) ->
      requestNotificationsIfNot() if jobMatch message.job

    $scope.search = ->
      reloadNotifications().then ->
        jQuery('#alert-search-content').val("")

    $scope.nextPage = ->
      $scope.page++
      reloadNotifications()

    $scope.previousPage = ->
      $scope.page--
      reloadNotifications()

    $scope.firstPage = ->
      $scope.page = 1
      reloadNotifications()

    $scope.lastPage = ->
      $scope.page = $scope.pages
      reloadNotifications()