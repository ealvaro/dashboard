Erdos.controller "FormationsController", ($scope) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.clients = []

  $scope.init = (json) ->
    $scope.clients = JSON.parse(json)
    $scope.loading = false


  $scope.headers = [
    {
      ordered: true,
      key: 'name',
      label: 'Name'
    },
    {
      key: 'multiplier',
      label: 'Multiplier'
    }
  ]

  $scope.exportColumnKeys = [
    "name",
    "multiplier"
  ]
