Erdos.controller "PricingSchemesController", ($scope, $http) ->
  $scope.show = false
  $scope.edit = false
  $scope.new_value = {}
  $scope.changed = false

  $scope.showInit = (id)->
    $scope.show = true
    $scope.pricing = {id: id}
    $scope.resetScheme()

  $scope.getKeys = (object) ->
    return object.customizable_attrs

  $scope.numericKeys = (object) ->
    tmp = []
    for key in Object.keys(object)
      unless /[a-zA-Z]/i.test(key)
        tmp.push key
    tmp

  $scope.addNewValue = ->
    $scope.sanitizeInput()
    $scope.valid()
    unless Object.keys($scope.new_value.errors).length > 0
      $scope.pricing[$scope.new_value.key][$scope.new_value.threshold] = { "amount" : $scope.new_value.amount, "description" : $scope.new_value.description }
      $scope.changed = true
      return $scope.new_value = {}


  $scope.deleteBracket = (key, threshold) ->
    if confirm("Deleting a pricing bracket is unrecoverable. Continue?")
      delete $scope.pricing[key][threshold]
      $scope.changed = true

  $scope.apply = ->
    $http({method: "PATCH", url: '/push/pricing_schemes/' + $scope.pricing.id.toString(), data: {"pricing_scheme":$scope.pricing}}).success (response) ->
      $scope.pricing = response
      $scope.changed = false

  $scope.resetScheme = ->
    $http({method: "GET", url: '/push/pricing_schemes/' + $scope.pricing.id.toString()}).success (response) ->
      $scope.pricing = response

  $scope.valid = ->
    $scope.new_value.errors = {}
    thres = undefined
    amount = undefined
    description = undefined
    try
      thres = parseFloat($scope.new_value.threshold)
      throw "NaN" if isNaN(thres)
    catch
      $scope.new_value.errors["threshold"] = "Invalid threshold" unless thres

    try
      amount = parseFloat($scope.new_value.amount)
      throw "NaN" if isNaN(amount)
      amount *= 100
      $scope.new_value.amount = amount
    catch
      $scope.new_value.errors["amount"] = "Invalid amount" unless amount

    $scope.new_value.errors["key"] = "Invalid key" if !$scope.new_value.key || $scope.new_value.key == ""
    $scope.new_value.errors["description"] = "Invalid description" if !$scope.new_value.description || $scope.new_value.description == ""

  $scope.sanitizeInput = ->
    try
      $scope.new_value.amount = $scope.new_value.amount.replace(/[$,]/g, "")
    catch
      true
