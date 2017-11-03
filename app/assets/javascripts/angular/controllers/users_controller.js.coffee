Erdos.controller "UsersController", ($scope, $http, User, Receiver) ->
  $scope.job = {}
  $scope.activeJobs = []

  $scope.droppableOptions = {
    multiple: true
    onDrop: 'dropFunction'
  }

  $scope.dropFunction = (event, ui) ->
    for klass in ui.draggable[0].classList
      #adding to exclude items
      if klass == 'exclude-item'
        collection = this.view_value.availableHeaders
        break
      if klass == 'include-item'
        collection = this.view_value.selectedHeaders

    key = this.dndDragItem.key
    index = 0
    for item in collection
      if item.key == key
        collection.splice(index, 1)
        break
      else
        index += 1

  $scope.init = (json, tab) ->
    $scope.tab = tab || 'Subscriptions'
    $scope.user = JSON.parse( json )
    refreshMultiselects()
    setTotalHeaders($scope.user.settings.headers)
    getJobs()

  getJobs = ->
    receivers = Receiver.query ->
      receivers.forEach (receiver) ->
        job = receiver.name
        if $scope.user.follows.indexOf(job) == -1
          $scope.activeJobs.push job

  $scope.save = ->
    $scope.saving = true
    if $scope.tab == "Headers"
      $scope.user.settings.headers = {}

      for view_key in Object.keys($scope.totalHeaders)
        $scope.user.settings.headers[view_key] = {headers:[]}
        for header in $scope.totalHeaders[view_key].selectedHeaders
          $scope.user.settings.headers[view_key].headers.push header

    unless $scope.tab == 'Account'
      $scope.user.password = undefined
      $scope.user.confirmation_password = undefined

    User.update($scope.user).$promise.then (user) ->
      delete $scope.saving
      $scope.user = user
      refreshMultiselects()
      if !$scope.user.errors || Object.keys($scope.user.errors).length == 0
        window.location = "/users/#{$scope.user.id}"

  $scope.addJob = ->
    $scope.adding = true
    $http({method: "POST", url: '/push/subscriptions', data:{user_id: $scope.user.id, job: {name: $scope.job.name}}}).success (data) ->
      $scope.errors = data.errors
      delete $scope.adding
      unless _.size($scope.errors) > 0
        $scope.errors = undefined
        User.get({id: $scope.user.id}).$promise.then (user) ->
          $scope.user = user
          delete $scope.adding
          $scope.job = {}
          refreshMultiselects()

  $scope.setTab = (name) ->
    refreshMultiselects()
    $scope.tab = name

  $scope.remove = (subscription) ->
    $http({method: 'DELETE', url: "/push/subscriptions/#{subscription.id}"}).success ->
      refreshMultiselects()
      User.get({id: $scope.user.id}).$promise.then (user) ->
        $scope.user.subscriptions = user.subscriptions
        refreshMultiselects()

  $scope.toggleNewSetting = ->
    if $scope.newSetting
      delete $scope.newSetting
    else
      $scope.newSetting = {}

  $scope.saveNewSetting = ->
    $scope.newSetting.user_id = $scope.user.id
    $scope.newSetting.pump_off_time_in_milliseconds = $scope.newSetting.pump_off_time_in_minutes * 1000
    $http({method: 'POST', url: '/push/threshold_settings', data:{threshold_setting: $scope.newSetting}}).success (data) ->
      if !data.errors || _.keys(data.errors).length == 0
        delete $scope.newSetting
        location.reload()
      else
        $scope.newSetting = data

  refreshMultiselects = ->
    setTimeout(->
      $('.interests').multiselect()
    , 5
    )

  setTotalHeaders = (headersSettings) ->
    return false unless headersSettings
    for view_key in Object.keys(headersSettings)
      for header in (headersSettings[view_key].headers || [])
        index = 0
        for t_head in $scope.totalHeaders[view_key].availableHeaders
          if header.key == t_head.key
            $scope.totalHeaders[view_key].selectedHeaders.push($scope.totalHeaders[view_key].availableHeaders[index])
            $scope.totalHeaders[view_key].availableHeaders.splice(index, 1)
            break
          else
            index += 1


  $scope.totalHeaders = {
    tools:{
      label: "Tools"
      selectedHeaders:[]
      availableHeaders: [
        {
          ordered: true,
          key: 'tool_type.name',
          label: 'Type'
        },
        {
          ordered: true,
          key: 'cache.board_serial_number',
          label: 'Board Serial #'
        },
        {
          ordered: true,
          key: 'cache.primary_asset_number',
          label: 'Asset #'
        },
        {
          ordered: true,
          key: 'cache.secondary_asset_numbers',
          label: 'Secondary Asset #s'
        },
        {
          ordered: true,
          key: 'cache.job_number',
          label: 'Job'
        },
        {
          ordered: true,
          key: 'cache.run_number',
          label: 'Run'
        },
        {
          ordered: false,
          key: 'cache.memory_usage_level',
          label: 'Mem Lvl'
        },
        {
          ordered: true,
          key: 'cache.hardware_version',
          label: 'HW'
        },
        {
          ordered: true,
          key: 'cache.board_firmware_version',
          label: 'FW'
        },
        {
          ordered: true,
          key: 'cache.max_temperature',
          label: 'Max Temp'
        },
        {
          ordered: true,
          key: 'total_service_time',
          label: 'Total Service Time'
        },
        {
          ordered: true,
          key: 'cache.event_assets',
          label: 'Event Assets'
        },
        {
          ordered: true,
          key: 'cache.created_at',
          label: 'Last Connected'
        },
        {
          ordered: true,
          key: 'uid',
          label: 'UID'
        }
      ]
    },
    memories: {
      label: "Memories"
      selectedHeaders: []
      availableHeaders: [
        {
          ordered: true,
          key: 'event_type',
          label: 'Event Type'
        },
        {
          ordered: true,
          key: 'hardware_version',
          label: 'HW'
        },
        {
          ordered: true,
          key: 'board_firmware_version',
          label: 'FW'
        },
        {
          ordered: true,
          key: 'job_number',
          label: 'Job'
        },
        {
          ordered: true,
          key: 'run_number',
          label: 'Run'
        },
        {
          ordered: true,
          key: 'board_serial_number',
          label: 'Board Serial #'
        },
        {
          ordered: true,
          key: 'primary_asset_number',
          label: 'Asset'
        },
        {
          ordered: true,
          key: 'secondary_asset_numbers',
          label: 'Secondary Asset #s'
        },
        {
          ordered: true,
          key: 'reporter_context',
          label: 'Reporter Context'
        },
        {
          ordered: true,
          key: 'user_email',
          label: 'Email'
        },
        {
          ordered: true,
          key: 'region',
          label: 'Region'
        },
        {
          ordered: false,
          key: 'memory_usage_level',
          label: 'Mem Usage Level'
        },
        {
          ordered: true,
          key: 'event_assets',
          label: 'Event Assets'
        },
        {
          ordered: true,
          key: 'max_temperature',
          label: 'Max Temp'
        },
        {
          ordered: true,
          key: 'time',
          label: 'Time'
        }
      ]
    },
    receivers: {
      label: "Active Jobs"
      selectedHeaders: []
      availableHeaders: [
        {
          ordered: true,
          key: 'reporter_version',
          label: 'Version'
        },
        {
          ordered: true,
          key: 'uid',
          label: 'UID'
        },
        {
          ordered: true,
          key: 'job',
          label: 'Job'
        },
        {
          ordered: false,
          key: 'run',
          label: 'Run'
        },
        {
          ordered: true,
          key: 'client',
          label: 'Client'
        },
        {
          ordered: true,
          key: 'rig',
          label: 'Rig'
        },
        {
          ordered: true,
          key: 'well',
          label: 'Well'
        },
        {
          ordered: false,
          key: 'last_updates.LeamReceiverUpdate.team_viewer_id',
          label: 'LRx TV ID'
        },
        {
          ordered: false,
          key: 'last_updates.LeamReceiverUpdate.team_viewer_password',
          label: 'LRx TV Pwd'
        },
        {
          ordered: false,
          key: 'last_updates.BtrReceiverUpdate.team_viewer_id',
          label: 'BTR TV ID'
        },
        {
          ordered: false,
          key: 'last_updates.BtrReceiverUpdate.team_viewer_password',
          label: 'BTR TV Pwd'
        },
        {
          ordered: false,
          key: 'last_updates.BtrControlUpdate.team_viewer_id',
          label: 'BTR Ctrl TV ID'
        },
        {
          ordered: false,
          key: 'last_updates.BtrControlUpdate.team_viewer_password',
          label: 'BTR Ctrl Pwd'
        },
        {
          ordered: false,
          key: 'last_updates.EmReceiverUpdate.team_viewer_id',
          label: 'APS EM TV ID'
        },
        {
          ordered: false,
          key: 'last_updates.EmReceiverUpdate.team_viewer_password',
          label: 'APS EM TV Pwd'
        },
        {
          ordered: false,
          key: 'last_updates.LoggerUpdate.team_viewer_id',
          label: 'Logger TV ID'
        },
        {
          ordered: false,
          key: 'last_updates.LoggerUpdate.team_viewer_password',
          label: 'Logger TV Pwd'
        },
        {
          ordered: false,
          key: 'decode_percentage',
          label: 'Decode %'
        },
        {
          ordered: false,
          key: 'pump_on_time',
          label: 'Pump On Time'
        },
        {
          ordered: false,
          key: 'inc',
          label: 'INC'
        },
        {
          ordered: false,
          key: 'average_quality',
          label: 'Average Quality'
        },
        {
          ordered: false,
          key: 'time_stamp',
          label: 'Time'
        },
        {
          ordered: false,
          key: 'tf',
          label: 'TF'
        },
        {
          ordered: false,
          key: 'tfo',
          label: 'TFO'
        },
        {
          ordered: false,
          key: 'dao',
          label: 'DAO'
        },
        {
          ordered: false,
          key: 'pump_off_time',
          label: 'Pump Off Time'
        },
        {
          ordered: false,
          key: 'pump_total_time',
          label: 'Pump Total Time'
        },
        {
          ordered: false,
          key: 'azm',
          label: 'AZM'
        },
        {
          ordered: false,
          key: 'gravity',
          label: 'Gravity'
        },
        {
          ordered: false,
          key: 'magf',
          label: 'MagF'
        },
        {
          ordered: false,
          key: 'dipa',
          label: 'DIPA'
        },
        {
          ordered: false,
          key: 'temp',
          label: 'Temperature'
        },
        {
          ordered: false,
          key: 'gama',
          label: 'Gama'
        },
        {
          ordered: false,
          key: 'gamma_shock',
          label: 'Gamma Shock (g)'
        },
        {
          ordered: false,
          key: 'gamma_shock_axial_p',
          label: 'Gamma Axial Shock (g)'
        },
        {
          ordered: false,
          key: 'gamma_shock_tran_p',
          label: 'Gamma Transverse Shock (g)'
        },
        {
          ordered: false,
          key: 'atfa',
          label: 'ATFA'
        },
        {
          ordered: false,
          key: 'gtfa',
          label: 'GTFA'
        },
        {
          ordered: false,
          key: 'mtfa',
          label: 'MTFA'
        },
        {
          ordered: false,
          key: 'delta_mtf',
          label: 'Delta MTF'
        },
        {
          ordered: false,
          key: 'formation_resistance',
          label: 'Formation Resistance'
        },
        {
          ordered: false,
          key: 'mx',
          label: 'Mx'
        },
        {
          ordered: false,
          key: 'my',
          label: 'My'
        },
        {
          ordered: false,
          key: 'mz',
          label: 'Mz'
        },
        {
          ordered: false,
          key: 'ax',
          label: 'Ax'
        },
        {
          ordered: false,
          key: 'ay',
          label: 'Ay'
        },
        {
          ordered: false,
          key: 'az',
          label: 'Az'
        },
        {
          ordered: false,
          key: 'batv',
          label: 'BATV'
        },
        {
          ordered: false,
          key: 'bat2',
          label: 'BAT2'
        },
        {
          ordered: false,
          key: 'batw',
          label: 'BATW'
        },
        {
          ordered: false,
          key: 'dipw',
          label: 'DIPW'
        },
        {
          ordered: false,
          key: 'gravw',
          label: 'GRAVW'
        },
        {
          ordered: false,
          key: 'gv0',
          label: 'GV0'
        },
        {
          ordered: false,
          key: 'gv1',
          label: 'GV1'
        },
        {
          ordered: false,
          key: 'gv2',
          label: 'GV2'
        },
        {
          ordered: false,
          key: 'gv3',
          label: 'GV3'
        },
        {
          ordered: false,
          key: 'gv4',
          label: 'GV4'
        },
        {
          ordered: false,
          key: 'gv5',
          label: 'GV5'
        },
        {
          ordered: false,
          key: 'gv6',
          label: 'GV6'
        },
        {
          ordered: false,
          key: 'gv7',
          label: 'GV7'
        },
        {
          ordered: false,
          key: 'magw',
          label: 'MAGW'
        },
        {
          ordered: false,
          key: 'tempw',
          label: 'TEMPW'
        },
        {
          ordered: false,
          key: 'dl_enabled',
          label: 'Downlink Enabled'
        },
        {
          ordered: false,
          key: 'sync_marker',
          label: 'Sync Marker'
        },
        {
          ordered: false,
          key: 'survey_sequence',
          label: 'SuSq'
        },
        {
          ordered: false,
          key: 'logging_sequence',
          label: 'TLSq'
        },
        {
          ordered: false,
          key: 'confidence_level',
          label: 'Confidence Level'
        },
        {
          ordered: false,
          key: 'pump_state',
          label: 'Pump State'
        },
        {
          ordered: false,
          key: 'rop',
          label: 'ROP'
        },
        {
          ordered: false,
          key: 'hole_depth',
          label: 'Hole Depth'
        },
        {
          ordered: false,
          key: 'bit_depth',
          label: 'Bit Depth'
        },
        {
          ordered: false,
          key: 'power',
          label: 'Power'
        },
        {
          ordered: false,
          key: 'dl_power',
          label: 'Downlink Power'
        },
        {
          ordered: false,
          key: 'battery_number',
          label: 'Battery Used'
        },
        {
          ordered: false,
          key: 'frequency',
          label: 'Frequency(Hz)'
        },
        {
          ordered: false,
          key: 'signal',
          label: 'Signal'
        },
        {
          ordered: false,
          key: 'mag_dec',
          label: 'MagDec'
        },
        {
          ordered: false,
          key: 's_n_ratio',
          label: 'S:N Ratio'
        },
        {
          ordered: false,
          key: 'noise',
          label: 'Noise'
        },
        {
          ordered: true,
          key: 'time_stamp',
          label: 'Last Updated'
        },
        {
          ordered: false,
          key: 'block_height',
          label: 'Block Height'
        },
        {
          ordered: false,
          key: 'hookload',
          label: 'Hookload'
        },
        {
          ordered: false,
          key: 'last_updates.LoggerUpdate.pump_pressure',
          label: 'Pump Pressure'
        },
        {
          ordered: false,
          key: 'annular_pressure',
          label: 'Annular Pressure'
        },
        {
          ordered: false,
          key: 'bore_pressure',
          label: 'Bore Pressure'
        },
        {
          ordered: false,
          key: 'weight_on_bit',
          label: 'WOB'
        },
        {
          ordered: false,
          key: 'rotary_rpm',
          label: 'Rotary RPM'
        },
        {
          ordered: false,
          key: 'voltage',
          label: 'Voltage'
        },
        {
          ordered: false,
          key: 'api',
          label: 'API'
        },
        {
          ordered: false,
          key: 'grav_roll',
          label: 'Gravity Roll'
        },
        {
          ordered: false,
          key: 'mag_roll',
          label: 'Mag Roll'
        },
        {
          ordered: false,
          key: 'survey_md',
          label: 'Survey MD'
        },
        {
          ordered: false,
          key: 'survey_tvd',
          label: 'Survey TVD'
        },
        {
          ordered: false,
          key: 'survey_vs',
          label: 'Survey VS'
        },
        {
          ordered: false,
          key: 'temperature',
          label: 'Temperature'
        },
        {
          ordered: false,
          key: 'pumps_on',
          label: 'Pumps On'
        },
        {
          ordered: false,
          key: 'on_bottom',
          label: 'On Bottom'
        },
        {
          ordered: false,
          key: 'slips_out',
          label: 'Slips Out'
        }
      ]
    },
    installs: {
      label: "Installs"
      selectedHeaders: []
      availableHeaders: [
        {
          ordered: true,
          key: 'updated_at',
          label: 'Last Updated'
        },
        {
          ordered: true,
          key: 'version',
          label: 'Version'
        },
        {
          ordered: true,
          key: 'team_viewer_id',
          label: 'Team Viewer ID'
        },
        {
          ordered: true,
          key: 'user_email',
          label: "User's Email"
        },
        {
          ordered: true,
          key: 'region',
          label: 'Region'
        },
        {
          ordered: true,
          key: 'reporter_context',
          label: 'Reporter Context'
        },
        {
          ordered: true,
          key: 'job_number',
          label: 'Job'
        },
        {
          ordered: true,
          key: 'run_number',
          label: 'Run'
        }
      ]
    }

  }
