Erdos.controller "ImportsController", ($scope, Client) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.imports = []

  $scope.init = (imports_json)->
    $scope.imports = JSON.parse(imports_json)
    $scope.loading = false

  $scope.headers = [
    {
      ordered: true,
      key: 'user.name',
      label: 'User'
    },
    {
      ordered: true,
      key: 'started_at',
      label: 'Started At'
    },
    {
      ordered: true,
      key: 'ended_at',
      label: 'Ended At'
    },
    {
      ordered: true,
      key: 'status',
      label: 'Status'
    }
  ]

  $scope.exportColumnKeys = [
    "user.name",
    "user.email",
    "started_at",
    "ended_at",
    "status"
  ]
