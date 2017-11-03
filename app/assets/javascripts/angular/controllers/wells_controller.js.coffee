Erdos.controller "WellsController", ($scope) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.wells = []

  $scope.init = (wells_json) ->
    $scope.wells = JSON.parse(wells_json)
    $scope.loading = false

  $scope.headers = [
    {
      ordered: true,
      key: 'name',
      label: 'Name',
      url: 'show_url'
    },
    {
      ordered: true,
      key: 'formation.name',
      label: 'Formation'
    }
  ]

  $scope.exportColumnKeys = [
    "name",
    "formation.name"
  ]
