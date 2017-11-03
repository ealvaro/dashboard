Erdos.controller "RunRecordsController", ($scope) ->
  $scope.run_records = []
  $scope.loading = true
  $scope.searchText = ""
  $scope.init = (json) ->
    $scope.run_records = JSON.parse( json )
    $scope.loading = false

  $scope.headers = [
    {
      ordered: true,
      key: 'job.name',
      label: 'Job',
      url: 'job_show_url'
    },
    {
      ordered: true,
      key: 'run.number',
      label: 'Run',
      url: 'run.show_url'
    },
    {
      ordered: true,
      key: 'tool.serial_number',
      label: 'Tool',
      url: 'tool.billing_show_url'
    },
    {
      ordered: true,
      key: 'tool.tool_type.name',
      label: 'Tool Type'
    }
  ]

  $scope.exportColumnKeys = [
    "job.name",
    "run.number",
    "tool.serial_number",
    "tool.tool_type.name"
    "max_temperature",
    "item_start_hrs",
    "circulating_hrs",
    "rotating_hours",
    "sliding_hours",
    "total_drilling_hours",
    "mud_weight",
    "gpm",
    "bit_type",
    "motor_bend",
    "rpm",
    "chlorides",
    "sand",
    "brt",
    "art",
    "created_at",
    "updated_at",
    "import_id",
    "bha",
    "agitator_distance",
    "mud_type",
    "agitator",
    "max_shock",
    "max_vibe",
    "shock_warnings"
  ]
