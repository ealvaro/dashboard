Erdos.controller "AlertsController", ($scope) ->
  $scope.searchText = ""
  $scope.loading = true

  $scope.init = (active_tab) ->
    $scope.loading = false
    $scope.tab = active_tab

  $scope.getDate = (date) ->
    if date
      moment( Date.parse( date ) )
    else
      undefined

  $scope.headers = [
    {
      ordered: false,
      key: 'subject',
      label: 'Subject'
    },
    {
      ordered: true,
      key: 'created_at',
      label: 'When'
      css_class: 'text-right'
    },
  ]

  $scope.exportColumnKeys = [
    "subject",
    "description",
    "created_at",
    "alertable.job.name",
    "alertable.run.number"
  ]
