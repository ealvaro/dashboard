Erdos.directive "erdosReceiverRadarChartEm", () ->
  restrict: 'E'
  replace: true
  scope:
    channel: '='
  templateUrl: "erdos_receiver_radar_chart_em.html"
  controller: ($scope) ->
    $scope.init = () ->
      # $scope.warningTypes = []
      # $scope.warnings = {}
      $scope.receiver_data = {}
      $scope.balls = []

    $scope.$on $scope.channel, (evt, data) ->
      $scope.updateBalls(data.tool_face_data)
      # checkWarnings data
      mergeData $scope.receiver_data, data

    $scope.updateBalls = (tool_face_data) ->
      $scope.time = new Date();
      $scope.balls = []
      for ball in _.sortBy(tool_face_data, (tf) ->
        tf.order)
        if ball.value && ball.value >= -180 && ball.value <= 360
          ball_id = ".#{$scope.channel} #ball" + String( ball.order )
          $scope.balls.splice(ball.order, 0, ball.value)
          $scope.setBallCoords( $scope.calculateCoords( ball.order ), ball_id )

    $scope.calculateCoords = (index) ->
      degrees = $scope.balls[index]
      radius = ( 280 / 2) - ( index * 20 ) - 2
      radians = degrees * ( Math.PI / 180 )
      radians = radians - ( Math.PI / 2 ) #shift to put 0 degrees at the top
      [ 20 + 2.5 + radius * Math.cos( radians ), 20 + 2.5 + radius * Math.sin( radians ) ]


    $scope.setBallCoords = ( coords, ball_id ) ->
      $( ball_id ).css( "position", "absolute" );
      $( ball_id ).css( "marginLeft", String( coords[0] ) + "px" );
      $( ball_id ).css( "marginTop", String( coords[1] ) + "px" );

    mergeData = (current_data, update) ->
      time = update.time
      for own key, value of update
        if value?
          if !current_data[key]?
            current_data[key] = { value: value, time: time }
          else if (current_data[key].value != value)
            current_data[key] = { value: value, time: time }

    # warnings not currently used for em
    # checkWarnings = (update) ->
    #   for own key,value of update
    #     if _.contains($scope.warningTypes, key)
    #       $scope.warnings[key] = value