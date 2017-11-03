Erdos.controller "ClientsController", ($scope, Client) ->
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
      label: 'Name',
      url: 'show_url'
    }
  ]

  $scope.exportColumnKeys = [
    "name",
    "address_street",
    "address_city",
    "address_state",
    "zip_code",
    "country"
  ]
