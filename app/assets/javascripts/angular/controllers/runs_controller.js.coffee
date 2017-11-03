Erdos.controller "RunsController", ($scope) ->
  $scope.runs = {}
  $scope.searchText = ""
  $scope.loading = true
  $scope.init = (json) ->
    $scope.runs = jQuery.parseJSON( json )
    $scope.loading = false

  $scope.headers = [
    {
      ordered: true,
      key: 'number',
      label: 'Number',
      url: 'show_url'
    },
    {
      ordered: true,
      key: 'job.name',
      label: 'Job'
    },
    {
      ordered: true,
      key: 'well.name',
      label: 'Well'
    },
    {
      ordered: true,
      key: 'rig.name',
      label: 'Rig'
    },
    {
      ordered: true,
      key: 'occurred',
      label: 'Occurred'
    }
  ]

  $scope.exportColumnKeys = [
    "number",
    "job.name",
    "well.name",
    "rig.name",
    "occurred"
  ]
