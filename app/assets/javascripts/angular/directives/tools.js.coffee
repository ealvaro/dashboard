Erdos.directive "tools", ($http, User) ->
  restrict: 'AEC'
  replace: true
  templateUrl: "tools.html.erb"
  controller: ($scope, $filter) ->
    $scope.filterType = ""
    $scope.loading = true
    $scope.reverse = false
    $scope.filter_types = []
    $scope.tools = []
    $scope.tool = {}
    $scope.currentPage = 1
    $scope.searchText = ""
    $scope.pages = 1
    $scope.currentUser = User.currentUser()
    $scope.currentUser.$promise.then (user) ->
      $scope.headers = user.settings.headers.tools.headers
      $scope.originalHeaders = angular.copy(user.settings.headers.tools.headers)

    $scope.$watch 'filterType', ->
      $scope.currentPage = 1
      $scope.searchText = ''
      refilter()

    $scope.$watch 'tools', ->
      refilter()
    , true

    refilter = ->
      fetchTools()
      $scope.filteredTools = $filter('toolFilter')($scope.tools, $scope.filterType)

    $scope.init = () ->
      fetchTools()
      $scope.setFilterTypes()

    $scope.showInit = (tool_json) ->
      $scope.tool = JSON.parse( tool_json )

    $scope.setFilterType = ( name ) ->
      if name == ""
        $scope.headers = $scope.originalHeaders
      else
        headers = []
        health_algorithm_included = -1
        index = 0
        for header in $scope.headers
          if header.key == 'cache.configs.health_algorithm'
            health_algorithm_included = index
          headers.push(header) unless header.key == 'tool_type.name'
          index += 1
        if name == "Dual Gamma"
          headers.push({ordered: true, key: 'cache.configs.health_algorithm', label: 'Health Algorithm'}) unless health_algorithm_included > -1
        else if name == "Smart Battery"
          headers = [
            {
              ordered: false,
              key: 'uid',
              label: 'UID'
            },
            {
              ordered: true,
              key: 'serial_number',
              label: 'Board Serial #'
            },
            {
              ordered: true,
              key: 'cache.primary_asset_number',
              label: 'Asset #'
            },
            {
              ordered: true,
              key: 'cache.can_id',
              label: 'CAN'
            },
            {
              ordered: false,
              key: 'cache.configs.amp_hour_expended',
              label: 'Hours Exp'
            },
            {
              ordered: false,
              key: 'cache.configs.circulating_hours',
              label: 'Circ Hours'
            },
            {
              ordered: false,
              key: 'cache.configs.pulse_count',
              label: 'Pulse Count'
            },
            {
              ordered: false,
              key: 'cache.configs.battery_voltage',
              label: 'Bat V'
            },
            {
              ordered: false,
              key: 'cache.configs.non_circulating_hours',
              label: 'Non Circ Hours'
            },
            {
              ordered: false,
              key: 'cache.configs.temperature',
              label: 'Temperature'
            }
          ]
        else if health_algorithm_included > -1
          headers.splice(health_algorithm_included, 1)
        $scope.headers = headers
      $scope.filterType = name
      setExportColumnKeys()

    $scope.getDate = (tool) ->
      if tool && tool.cache.created_at
        moment( Date.parse( tool.cache.created_at ) )
      else
        undefined

    $scope.setFilterTypes = ->
      names = [
        "Sensor Interface", "Pulser Driver", "Dual Gamma", "Receiver",
        "Smart Battery", "Dual Gamma Lite", "Smart Lower End", "BTR Control",
        "BTR Monitor", "LRx", "APS EM Rx"
      ]
      for name in names
        if $scope.filter_types.indexOf( name ) == -1
          $scope.filter_types.push( name )

    $scope.headers = []

    $scope.originalHeaders = []

    $scope.coreExportColumnKeys = [
      "tool_type.name",
      "board_serial_number",
      "uid_display",
      "primary_asset_number",
      "job_number",
      "run_number",
      "memory_usage_level",
      "hardware_version",
      "board_firmware_version",
      "chassis_serial_number",
      "time",
      "max_temperature",
      "max_shock",
      "client_name",
      "event_type",
      "notes",
      "region",
      "reporter_context",
      "rig_name",
      "secondary_asset_numbers",
      "shock_counts",
      "status",
      "user_email",
      "well_name"
    ]

    smartBatteryAvailableAttributes = [
      "tool_type.name",
      "can_id",
      "board_serial_number",
      "primary_asset_number",
      "configs.amp_hour_expended",
      "configs.circulating_hours",
      "configs.pulse_count",
      "configs.battery_voltage",
      "configs.non_circulating_hours",
      "configs.temperature"
    ]

    dualGammaAvailableAttributes = [
      "configs.downhole_api_val",
      "configs.min_threshold",
      "configs.idle_logging_interval",
      "configs.sample_period",
      "configs.max_threshold",
      "configs.vibration_threshold",
      "configs.k_skew",
      "configs.voltage_event_max",
      "configs.high_low_percentage",
      "configs.uphole_api_val",
      "configs.low_timeout",
      "configs.voltage_event_delta",
      "configs.diff_diversion",
      "configs.diff_diversion_high",
      "configs.k_kurt",
      "configs.logging_timeout",
      "configs.running_avg_window",
      "configs.shock_threshold",
      "configs.div_crossing_thresh",
      "configs.voltage_event_min",
      "configs.qbus_sleep_time",
      "configs.logging_interval",
      "configs.high_timeout",
      "configs.k_std",
      "configs.requalification_time",
      "configs.diversion_integral",
      "configs.diversion_window"
    ]

    pulserAvailableAttributes = [
      "configs.accel_thresh_ad_off",
      "configs.accel_thresh_ad_strongly_on",
      "configs.accel_thresh_ad_weakly_on",
      "configs.accel_thresh_dd_off",
      "configs.accel_thresh_dd_strongly_on",
      "configs.accel_thresh_dd_weakly_on",
      "configs.accel_thresh_hg_off",
      "configs.accel_thresh_hg_strongly_on",
      "configs.accel_thresh_hg_weakly_on",
      "configs.battery_hi",
      "configs.battery_lo",
      "configs.logging_interval",
      "configs.pulse_close_duty",
      "configs.pulse_close_period",
      "configs.pulse_hold_duty",
      "configs.pulse_max",
      "configs.pulse_min",
      "configs.shock_axial",
      "configs.shock_radial",
      "configs.st_dev_filter",
      "configs.weights_ad_strongly_off",
      "configs.weights_ad_strongly_on",
      "configs.weights_ad_weakly_off",
      "configs.weights_ad_weakly_on",
      "configs.weights_hg_strongly_off",
      "configs.weights_hg_strongly_on",
      "configs.weights_hg_weakly_off",
      "configs.weights_hg_weakly_on",
      "configs.vib_trip_hi",
      "configs.vib_trip_hi_a",
      "configs.vib_trip_lo",
      "configs.vib_trip_lo_a"
    ]

    $scope.exportColumnKeys = angular.copy($scope.coreExportColumnKeys)

    setExportColumnKeys = ->
      switch $scope.filterType
        when 'Dual Gamma'
          $scope.exportColumnKeys = angular.copy($scope.coreExportColumnKeys).concat dualGammaAvailableAttributes
        when 'Pulser Driver'
          $scope.exportColumnKeys = angular.copy($scope.coreExportColumnKeys).concat pulserAvailableAttributes
        when 'Smart Battery'
          $scope.exportColumnKeys = angular.copy($scope.coreExportColumnKeys).concat smartBatteryAvailableAttributes
        else
          $scope.exportColumnKeys = $scope.coreExportColumnKeys

    fetchTools = ->
      $scope.loading = true
      $http.get('/v750/tools?page=' + $scope.currentPage + '&reverse=' + $scope.reverse + '&tool_type=' + $scope.filterType)
        .then (response) ->
          $scope.tools = response.data.tools
          $scope.pages = response.data.meta.pages
          $scope.results = response.data.meta.results
          $scope.loading = false

    $scope.filterName = ->
      if $scope.filterType == ""
        'Overview'
      else
        $scope.filterType
