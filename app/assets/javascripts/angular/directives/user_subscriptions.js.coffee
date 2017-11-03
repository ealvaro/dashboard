Erdos.directive "userSubscriptions", () ->
  restrict: 'E'
  replace: true
  templateUrl: "user_subscriptions.html.erb"
  scope:
    jobs: '='
    user: '='
  controller: ($scope, $http) ->
    $scope.follows = $scope.user.follows
    $scope.follow = (job) ->
      $http.post('/follow', user: {job: job})
        .then (response) ->
          $scope.follows = response.data
      index = $scope.jobs.indexOf job
      $scope.jobs.splice index, 1
    $scope.unfollow = (job) ->
      $http.post('/unfollow', user: {job: job})
        .then (response) ->
          $scope.follows = response.data
      index = $scope.jobs.indexOf job
      $scope.jobs.push job
