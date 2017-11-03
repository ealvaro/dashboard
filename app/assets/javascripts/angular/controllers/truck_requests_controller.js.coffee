Erdos.controller "TruckRequestsController", ($scope, $http) ->
  $scope.loading = true
  $scope.page = 1
  $scope.pages = 1
  $scope.tab = 'active'
  $scope.headers = ["Priority", "Date Requested", "Region", "Job Number",
                    "Requested By", "Motors", "MWD", "Surface", "Backhaul",
                    "Notes", "Status", "Action"]
  $scope.details = { "selected": false }

  $scope.getIndex = ->
    $scope.loading = true
    $http.get('/push/truck_requests.json', params: {
                                                     completed: $scope.tab == 'serviced',
                                                     keyword: $scope.keyword,
                                                     page: $scope.page
                                                    }
    ).then (response) ->
      $scope.truckRequests = response.data.truck_requests
      add_details()
      $scope.pages = response.data.meta.pages
      $scope.loading = false

  $scope.putUpdate = (id, status, notes) ->
    $scope.loading = true
    status = { "truck_request": { "status": { "context": status, "time": new Date(), "notes": notes } } }
    $http.put('/push/truck_requests/' + id + '.json', status).then (response) ->
      $scope.getIndex($scope.tab == 'serviced')

  add_details = ->
    for truckRequest in $scope.truckRequests
      jQuery.extend truckRequest, { "details": { "selected": false, "statuses": [] } }

  $scope.search = ->
    $scope.getIndex().then ->
      #Allow large searches to be paginated
      unless $scope.pages > 1
        $scope.keyword = ""

  $scope.truncate = (word) ->
    if word.length > 9
      word.substring(0 , 7) + '...'
    else
      word

  $scope.export = ->
    $scope.loading = true
    $http.post('/push/users/export_csv', objects_array: $scope.truckRequests).then (response) ->
      window.open( response.data.file.url, "_parent" )
      $scope.loading = false

  $scope.changePage = (page) ->
    $scope.page = page
    $scope.getIndex()

  $scope.last = (array) ->
    _.last(array)

  $scope.parseTime = (time) ->
    #convert to seconds since epoch
    new Date(time) / 1

  $scope.hideDetails = (truckRequest) ->
    truckRequest.details.selected = false

  $scope.showDetails = (truckRequest) ->
    truckRequest.details.selected = true
    #slice to create dup
    truckRequest.details.statuses = truckRequest.status_list.slice(0).reverse()