Erdos.controller "InstallsController", ($scope, $http, $filter, User) ->
  $scope.installs = []
  $scope.types = []
  $scope.filterType = "LConfig"
  $scope.loading = true
  $scope.searchText = ""
  $scope.filteredObjects = []
  $scope.currentUser = User.currentUser()
  $scope.currentUser.$promise.then (user) ->
    $scope.headers = user.settings.headers.installs.headers

  $scope.$watch('filterType', ->
    setFilteredObjects()
  )

  $scope.init = () ->
    $http( { method: "GET", url: '/push/installs' } ).success (response) ->
      $scope.loading = false
      $scope.installs = response
      $scope.setTypes( $scope.installs )
      setFilteredObjects()

  setFilteredObjects = ->
    $scope.filteredObjects = $filter('installType')($scope.installs, $scope.filterType)

  $scope.setTypes = (installs) ->
    for install in installs
      if $scope.types.indexOf( install.application_name ) == -1
        $scope.types.push install.application_name

  $scope.setFilterType = ( filterType ) ->
    $scope.filterType = filterType

  $scope.typeCount = ( type ) ->
    result = 0
    for install in $scope.installs
      if install.application_name == type
        result += 1
    result

  $scope.setOrderBy = ( attr ) ->
    if $scope.order_by == attr
      $scope.reverse = !$scope.reverse
    else
      $scope.order_by = attr

  $scope.getDate = ( install ) ->
    moment( Date.parse( install.updated_at ) )

  $scope.exportColumnKeys = [
    "version",
    "team_viewer_id",
    "team_viewer_password",
    "ip_address",
    "key",
    "dell_service_number",
    "user_email",
    "region",
    "reporter_context",
    "job_number",
    "run_number",
    "updated_at"
  ]

  $scope.headers = [ ]

