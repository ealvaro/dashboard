Erdos.directive "notifierCog", ($http, $window) ->
  restrict: 'E'
  replace: true
  templateUrl: "notifier_cog.html"
  scope:
    notifier: "="
    notifiers: "="
  controller: ($scope) ->
    $scope.editNotifier = ->
      $scope.$emit 'edit-notifier', $scope.notifier

    $scope.deleteNotifier = ->
      name = "#{$scope.notifier.name}"
      reallyDelete = "Are you sure you want to delete the '#{name}' alert?"
      if $window.confirm(reallyDelete)
        id = $scope.notifier.id
        $http(
          method: 'DELETE'
          url: "/notifiers/#{id}"
        ).success (response) ->
          index = $scope.notifiers.indexOf($scope.notifier)
          $scope.notifiers.splice(index, 1)

    $http(
      method: 'GET'
      url: '/push/users/permissions'
      params:
        feature: 'Notifier'
    ).success (permissions) ->
      $scope.permissions = permissions["Notifier"]

    $scope.showDetails = ->
      $scope.notifier.details = true

    $scope.userCanEdit = ->
      $scope.permissions?["update"]

    $scope.userCanDelete = ->
      $scope.permissions?["delete"]
