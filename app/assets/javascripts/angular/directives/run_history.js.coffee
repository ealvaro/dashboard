Erdos.directive "runHistory", ($http) ->
  restrict: 'E'
  replace: true
  scope:
    run: '='
  templateUrl: "run_history.html.erb"
  controller: ($scope) ->
    $scope.init = ->
      $http({method: 'GET', url: '/push/runs/' + $scope.run.id.toString()}).success (response) ->
        $scope.run = response

    $scope.hands = ->
      result = []
      emails = []
      if($scope.run && $scope.run.events)
        for event in $scope.run.events
          if event && event.user_email && event.user_email.length > 0
            value = {email: event.user_email}
            if emails.indexOf(event.user_email) == -1
              result.push value
              emails.push event.user_email
      if result.length > 0
        result
      else
        undefined
