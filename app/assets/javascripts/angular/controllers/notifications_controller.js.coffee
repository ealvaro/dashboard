Erdos.controller "NotificationsController", ($scope, $http) ->
  $scope.init = (active_tab, header_view) ->
    $scope.tab = active_tab

    full_headers = [
      {
        key: 'job_number',
        label: 'Job'
      },
      {
        key: 'description',
        label: 'Description'
      },
      {
        key: 'created_at',
        label: 'Time'
      },
      {
        key: 'completed_at',
        label: 'Time Cleared'
      },
      {
        key: 'completed_by',
        label: 'User Cleared'
      },
      {
        key: 'completed_status',
        label: 'Marked As'
      }
    ]

    quick_headers = [
      {
        key: 'description',
        label: 'Description'
      },
      {
        key: 'created_at',
        label: 'Time'
      }
    ]

    $scope.headers =
      switch header_view
        when "full_headers" then full_headers
        when "quick_headers" then quick_headers
        else full_headers

  $scope.handleTabClick = (event, active_tab) ->
    event.preventDefault()
    $scope.tab = active_tab
