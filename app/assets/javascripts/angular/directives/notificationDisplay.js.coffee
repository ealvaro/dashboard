Erdos.directive "notificationDisplay", ->
  restrict: 'E'
  replace: true
  templateUrl: "notification_display.html.erb"
  scope:
    jobNumbers: '='
  controller: ($scope) ->
    $scope.tab = 'Following'
    $scope.headers = [
      {
        key: 'selected',
        label: ' '
      },
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

    $scope.handleTabClick = (event, active_tab) ->
      event.preventDefault()
      $scope.tab = active_tab
