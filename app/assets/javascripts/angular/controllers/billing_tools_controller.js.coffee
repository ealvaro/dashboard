Erdos.controller "BillingToolsController", ($scope) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.init = (tools_json) ->
    $scope.tools = JSON.parse(tools_json)
    $scope.loading = false

  $scope.headers = [
    {
      ordered: true,
      key: 'serial_number',
      label: 'Serial Number',
      url: 'show_url'
    },
    {
      ordered: true,
      key: 'tool_type.name',
      label: 'Tool Type'
    },
    {
      ordered: true,
      key: 'tool_type.description',
      label: 'Tool Type Description'
    }
  ]

  $scope.exportColumnKeys = [
    "serial_number",
    "tool_type.name",
    "tool_type.description"
  ]
