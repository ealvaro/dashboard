Erdos.directive "userCog", ($http) ->
  restrict: 'E'
  replace: true
  templateUrl: "user_cog.html.erb"
  scope:
    user: "="
    users: "="
  controller: ($scope) ->
    $scope.destroy = (user) ->
      if confirm("Are you sure that you would like to permanently delete this user?")
        $http({method: 'DELETE', url: user.destroy_url}).success ->
          index = 0
          for object in $scope.users
            if object.id == user.id
              $scope.users.splice(index, 1)
              break
            index += 1
