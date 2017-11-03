Erdos.directive "erdosReceiverPusherListener", () ->
  restrict: "AEC"
  replace: true
  scope:
    jobNumber: "="
    receiverType: "="
    receiverData: "="
    object: "="
    objects: "="
  controller: ($scope, Pusher) ->
    if $scope.jobNumber?
      # show context
      unless $scope.$root.loggerUpdate
        $scope.$root.loggerUpdate = "logger-" + $scope.jobNumber.toLowerCase()
        Pusher.subscribe $scope.$root.loggerUpdate, 'update', (message) ->
          $scope.$root.$broadcast "logger-updated", message

      unless $scope.$root.leamReceiverUpdate
        $scope.$root.leamReceiverUpdate = "leam-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.leamReceiverUpdate, 'update', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "leam-receiver-updated", message

      unless $scope.$root.btrReceiverUpdate
        $scope.$root.btrReceiverUpdate = "btr-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.btrReceiverUpdate, 'update', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "btr-receiver-updated", message

      unless $scope.$root.btrControlUpdate
        $scope.$root.btrControlUpdate = "btr-control-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.btrControlUpdate, 'update', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "btr-control-receiver-updated", message

      unless $scope.$root.emReceiverUpdate
        $scope.$root.emReceiverUpdate = "em-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.emReceiverUpdate, 'update', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "em-receiver-updated", message

      unless $scope.$root.leamReceiverPulse
        $scope.$root.leamReceiverPulse = "leam-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.leamReceiverPulse, 'pulse', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "leam-receiver-pulse", message

      unless $scope.$root.btrReceiverPulse
        $scope.$root.btrReceiverPulse = "btr-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.btrReceiverPulse, 'pulse', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "btr-receiver-pulse", message

      unless $scope.$root.btrControlPulse
        $scope.$root.btrControlPulse = "btr-control-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.btrControlPulse, 'pulse', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "btr-control-receiver-pulse", message

      unless $scope.$root.emReceiverPulse
        $scope.$root.emReceiverPulse = "em-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.emReceiverPulse, 'pulse', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "em-receiver-pulse", message

      unless $scope.$root.emReceiverMicro
        $scope.$root.emReceiverMicro = "em-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.emReceiverMicro, 'micro', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "em-receiver-micro", message

      unless $scope.$root.emReceiverFft
        $scope.$root.emReceiverFft = "em-receiver-#{$scope.jobNumber.toLowerCase()}"
        Pusher.subscribe $scope.$root.emReceiverFft, 'fft', (message) ->
          if applicable(message)
            $scope.$root.$broadcast "em-receiver-fft", message

    else
      # index context
      unless $scope.$root.activeJobsUpdate
        $scope.$root.activeJobsUpdate = "active-jobs"
        Pusher.subscribe $scope.$root.activeJobsUpdate, 'update', (message) ->
          $scope.$root.$broadcast "active-jobs-updated", message

      unless $scope.$root.activeJobDataUpdate
        $scope.$root.activeJobDataUpdate = "active-job-data"
        Pusher.subscribe $scope.$root.activeJobDataUpdate, 'update', (message) ->
          $scope.$root.$broadcast "active-job-data", message

    applicable = (message) ->
      return true if $scope.object && $scope.object.uid == message.uid
      return true if $scope.jobNumber && $scope.jobNumber == message.job
      if $scope.objects
        for object in $scope.objects
          return true if object.uid == message.uid
      false
