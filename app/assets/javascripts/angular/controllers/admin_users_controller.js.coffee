Erdos.controller "AdminUsersController", ($scope) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.users = []

  $scope.init = (json) ->
    $scope.users = JSON.parse(json)
    $scope.loading = false


  $scope.headers = [
    {
      ordered: true,
      key: 'name',
      label: 'Name'
    },
    {
      key: 'roles',
      label: 'Roles'
    }
  ]

  $scope.exportColumnKeys = [
    "name",
    "roles"
  ]
