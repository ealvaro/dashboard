Erdos.directive "eventsTable", ($http, User) ->
  restrict: 'AEC'
  replace: true
  scope:
    events : '='
    uid : '='
    loading: '='
    results: '='
    pages: '='
  templateUrl: "events_table.html.erb"
  controller: ($scope) ->
    $scope.searchText = ''
    $scope.events = []
    $scope.orderBy = ""
    $scope.reverse = false
    $scope.event_types = []
    $scope.available_event_types = []
    $scope.memory_only = $scope.$parent.memory_only
    $scope.limit = 1000
    $scope.type = ""
    $scope.currentUser = User.currentUser()
    $scope.currentUser.$promise.then (user) ->
      $scope.headers = user.settings.headers.memories.headers

    $scope.exportColumnKeys = [
      "tool_type_name",
      "board_serial_number",
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
      "event_type",
      "notes",
      "region",
      "reporter_context",
      "secondary_asset_numbers",
      "shock_counts",
      "user_email"
    ]

    $scope.headers = []

    if $scope.memory_only
      $scope.limit = 50
      tool_type_header = {
        ordered: true,
        key: "tool_type_name",
        label: "Tool Type"
      }
      $scope.headers.splice(0,1, tool_type_header)
    $scope.show_events = []

    $scope.$watch 'events', ->
      if $scope.available_event_types && $scope.events
        for event in $scope.events
          if $scope.events.indexOf( event.event_type ) == -1 && $scope.available_event_types.indexOf( event.event_type ) == -1
            $scope.available_event_types.push( event.event_type )
        $scope.event_types = angular.copy( $scope.available_event_types )
        if !$scope.show_events || $scope.show_events.length != $scope.limit
          $scope.refreshShowEvents()

    $scope.refreshShowEvents = () ->
      counter = angular.copy( $scope.limit )
      $scope.show_events = []
      for event in angular.copy($scope.events)
        if counter > 0
          if ( $scope.type == "" || event.tool_type_name == $scope.type)
            $scope.show_events.push( event )
            counter -= 1
        else
          break

    $scope.setType = ( name ) ->
      if name == 'All'
        $scope.type = ''
      else
        $scope.type = name
      $scope.searchText = ''
      $scope.currentPage = 1
      fetchMemories()

    $scope.addType = (type) ->
      $scope.event_types.push type

    $scope.removeType = (type) ->
      index = $scope.event_types.indexOf( type )
      $scope.event_types.splice( index, 1 )

    $scope.getHiddenTypes = () ->
      if $scope.available_event_types.length > 0
        $scope.available_event_types.filter (x) ->
          $scope.event_types.indexOf( x ) == -1

    $scope.setOrderBy = (key) ->
      key = key.replace('cache.', '')
      if $scope.orderBy == key
        $scope.reverse = !$scope.reverse
      else
        $scope.orderBy = key
        $scope.reverse = false
      fetchMemories()

    $scope.getDate = (event, attr) ->
      if event && event[attr]
        moment( Date.parse( event[attr] ) )
      else
        undefined

    fetchMemories = ->
      $scope.loading = true
      $http.get('/v750/recent_memories?reverse=' + $scope.reverse +
                                        '&order=' + $scope.orderBy +
                                        '&type=' + $scope.type +
                                        '&search=' + $scope.searchText)
        .then (response) ->
          $scope.events = response.data.memories
          $scope.pages = response.data.meta.pages
          $scope.results = response.data.meta.results
          $scope.loading = false