Erdos.controller "ReportRequestsController", ($scope) ->
  $scope.loading = true
  $scope.searchText = ""
  $scope.reportRequests = []
  $scope.objects = 1
  $scope.currentPage = 1
  $scope.perPage = 20

  $scope.init = (report_requests_json) ->
    $scope.reportRequests = JSON.parse(report_requests_json)
    $scope.loading = false

  $scope.downloadAsset = (asset) ->
    window.open(asset.url, "_parent")

  $scope.getDate = (event, attr) ->
    if event && event[attr]
      moment( Date.parse( event[attr] ) )
    else
      undefined
