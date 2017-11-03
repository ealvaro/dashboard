Erdos.directive "invoiceRun", () ->
  restrict: 'E'
  replace: true
  templateUrl: "invoice_run.html.erb"
  scope:
    run: "="
    invoice: '='
  controller: ($scope) ->
    $scope.client = $scope.invoice.client
    $scope.run.dd_hours_as_billed = $scope.run.sliding_hours_as_billed + $scope.run.rotating_hours_as_billed
    $scope.run.mwd_hours_as_billed = $scope.run.circulating_hrs_as_billed


    $scope.$watch( 'run', (newRun, oldRun) ->
      if !equals( newRun.motor_bend_as_billed, oldRun.motor_bend_as_billed ) || !equals( newRun.rpm, oldRun.rpm )
        recalculateMotorBendDamages( newRun )
      if !equals( newRun.max_temperature_as_billed, oldRun.max_temperature_as_billed )
        recalculateDamages( newRun, "max_temperature" )
      if !equals( newRun.max_shock_as_billed, oldRun.max_shock_as_billed )
        recalculateDamages( newRun, "max_shock" )
      if !equals( newRun.max_vibe_as_billed, oldRun.max_vibe_as_billed )
        recalculateDamages( newRun, "max_vibe" )
      if !equals( newRun.agitator_distance_as_billed, oldRun.agitator_distance_as_billed )
        recalculateDamages( newRun, "agitator_distance" )
      if !equals( newRun.shock_warnings_as_billed, oldRun.shock_warnings_as_billed )
        recalculateDamages( newRun, "shock_warnings" )
      if !equals( newRun.mud_type_as_billed, oldRun.mud_type_as_billed ) || !equals( newRun.sand_as_billed, oldRun.sand_as_billed ) || !equals( newRun.chlorides_as_billed, oldRun.chlorides_as_billed )
        recalculateMudTypeDamages( newRun )
      if !equals( newRun.sliding_hours_as_billed, oldRun.sliding_hours_as_billed ) ||!equals( newRun.rotating_hours_as_billed, oldRun.rotating_hours_as_billed )
        $scope.run.dd_hours_as_billed = parseFloat( newRun.sliding_hours_as_billed ) +  parseFloat( newRun.rotating_hours_as_billed )
        recalculateDamages( newRun, "dd_hours" )
      if !equals( newRun.circulating_hrs_as_billed, oldRun.circulating_hrs_as_billed )
        $scope.run.mwd_hours_as_billed = parseFloat( newRun.circulating_hrs_as_billed )
        recalculateDamages( newRun, "mwd_hours" )
    , true )

    $scope.initDamages = () ->
      if $scope.run.damages && $scope.run.damages.length > 0
        $scope.run.damages_as_billed = {}
        for damage in $scope.run.damages
          $scope.run.damages_as_billed[damage.damage_group] = {
            amount: damage.amount_in_cents_as_billed,
            original_amount_in_cents: damage.original_amount_in_cents,
            description: damage.description,
            altered: true
            }
      else
        recalculateMotorBendDamages( $scope.run )
        recalculateDamages( $scope.run, "max_temperature" )
        recalculateDamages( $scope.run, "max_shock" )
        recalculateDamages( $scope.run, "max_vibe" )
        recalculateDamages( $scope.run, "shock_warnings" )
        recalculateDamages( $scope.run, "agitator_distance" )
        recalculateMudTypeDamages( $scope.run )
        recalculateDamages( $scope.run, "dd_hours" )


    recalculateMotorBendDamages = ( run ) ->
      unless run.damages_as_billed.motor_bend && run.damages_as_billed.motor_bend.altered
        motor_bend_damages = findDamagesForAttr( run, "motor_bend" )
        rpm_damages = findDamagesForAttr( run, "rpm" )
        $scope.run.damages_as_billed.motor_bend = {}
        if motor_bend_damages.amount > rpm_damages.amount
          $scope.run.damages_as_billed.motor_bend = motor_bend_damages
        else if rpm_damages.amount > 0
          $scope.run.damages_as_billed.motor_bend = rpm_damages

    recalculateMudTypeDamages = ( run ) ->
      if run.mud_type_as_billed && run.mud_type_as_billed.indexOf( "Water" ) > -1
        mud_type_pricing = $scope.client.pricing.mud_type.water_based_mud
        for attr in Object.keys(mud_type_pricing)
          unless run.damages_as_billed[attr] && run.damages_as_billed[attr].altered
            val = getMaxAmount(run, mud_type_pricing, attr)
            run.damages_as_billed[attr] = val
      else
        for attr in Object.keys($scope.client.pricing.mud_type.water_based_mud)
          unless run.damages_as_billed[attr] && run.damages_as_billed[attr].altered
            delete run.damages_as_billed[attr]



    findDamagesForAttr = ( run, attr ) ->
      pricing = $scope.client.pricing
      val = getMaxAmount(run,pricing,attr)
      $scope.run.damages_as_billed[attr] = val

    getMaxAmount = (run, pricing, attr) ->
      val = { 'amount': 0, 'description': "" }
      for key in Object.keys( pricing[attr] )
        #altered needs to win out all of the time
        if run[attr + "_as_billed"] && parseFloat( run[ attr + "_as_billed"] ) > parseFloat( key ) && val.amount < pricing[attr][key].amount
          val = pricing[attr][key]
      val.original_amount_in_cents = val.amount unless val.original_amount_in_cents
      return run.damages_as_billed[attr] if run.damages_as_billed[attr] && run.damages_as_billed[attr].altered && val.amount > 0
      val

    equals = ( attr1, attr2 ) ->
      parseFloat( attr1 ) == parseFloat( attr2 )

    recalculateDamages = ( run, attr ) ->
      $scope.run.damages_as_billed[attr] = findDamagesForAttr( run, attr )
