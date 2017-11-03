Erdos.directive "runDamages", () ->
  restrict: 'E'
  replace: true
  templateUrl: "run_damages.html.erb"
  scope:
    run: "="
    invoice: '='
  controller: ($scope) ->
    $scope.damages_as_billed = $scope.run.damages_as_billed
    $scope.run.damages_as_billed.subtotal = 0 unless $scope.run.damages_as_billed.subtotal

    $scope.$watch( 'run', (run) ->
      calculateSubtotal( run )
      true
    , true)

    $scope.$parent.$parent.$watch( 'invoice', ->
      calculateSubtotal($scope.run)
    , true)

    $scope.afterMultiplier = (amount) ->
      mult = angular.copy $scope.invoice.multiplier_as_billed
      if mult == null
        mult = 1
      parseFloat(amount) * mult

    $scope.deleteDamage = (key) ->
      delete $scope.run.damages_as_billed[key]

    $scope.addNewValue = ->
      prepareAddCustom()

      unless $scope.addCustom.errors
        key = "custom" + (new Date()).getTime().toString()
        $scope.addCustom.amount *= 100
        $scope.addCustom.altered = true
        $scope.run.damages_as_billed[key] = $scope.addCustom
        $scope.addCustom = undefined

    $scope.startAddCustom = ->
      $scope.addCustom = {}

    $scope.updateDamage = (damage) ->
      damage.errors = {}
      tmp = undefined
      try
        tmp = parseFloat(damage.decimal_amount.toString().replace(/[$,]/g, ""))
        throw "NaN" if isNaN(tmp)
      catch
        return damage.errors.decimal_amount = "is not properly formatted"

      delete damage.errors
      damage.amount = tmp * 100
      damage.altered = true
      delete damage.decimal_amount
      damage

    $scope.reset = (damage) ->
      damage.altered = false
      damage.amount = damage.original_amount_in_cents


    prepareAddCustom = ->
      $scope.addCustom.errors = {}
      tmp = undefined
      try
        tmp = parseFloat($scope.addCustom.amount.replace(/[$,]/g, ""))
        throw "NaN" if isNaN(tmp)
      catch
        $scope.addCustom.errors.amount = "is not properly formatted"

      $scope.addCustom.errors.description = "invalid description" if !$scope.addCustom.description || $scope.addCustom.description.replace(" ", "").length == 0

      if Object.keys($scope.addCustom.errors).length == 0
        delete $scope.addCustom.errors
        $scope.addCustom.amount = tmp

    calculateSubtotal = (run) ->
      amount = 0
      for key in Object.keys( run.damages_as_billed )
        amount += parseFloat( $scope.afterMultiplier(run.damages_as_billed[key].amount) ) if run.damages_as_billed[key].amount
      run.damages_as_billed.subtotal = amount
