Erdos.directive "receiverCog", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "receiver_cog.html.erb"
  scope:
    receiver: "="
    follows: '='
  controller: ($scope) ->
    $scope.job = $scope.receiver.name
    $scope.showDetails = (object) ->
      object.details = true

    $scope.showCopy = (type) ->
      last_updates = $scope.receiver.last_updates
      last_updates[type].team_viewer_id?

    $scope.copy = (type) ->
      last_updates = $scope.receiver.last_updates
      tv = last_updates[type].team_viewer_id
      copyToClipboard(tv)

    copyToClipboard = (text) ->
      window.prompt("Copy to clipboard: Ctrl+C, Enter", text);

    $scope.follow = (job) ->
      $http.post('/follow', user: {job: job})
        .then (response) ->
          $scope.follows = response.data

    $scope.unfollow = (job) ->
      $http.post('/unfollow', user: {job: job})
        .then (response) ->
          $scope.follows = response.data

    $scope.doesFollow = (job) ->
      $scope.follows?.indexOf(job) != -1
