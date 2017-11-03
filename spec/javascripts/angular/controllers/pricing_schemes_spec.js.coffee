describe "Pricing Schemes Controller", ->
  $scope = undefined
  ctrl = undefined

  beforeEach module( "erdos" )
  beforeEach inject( (_$rootScope_, $controller) ->
    $scope = _$rootScope_.$new();
    ctrl = $controller( "PricingSchemesController", { $scope, $scope } )
  )

  describe 'initialize', ->
    it "should set all of the fields correctly", ->
      expect($scope.show).toBe(false)
    it "should set all of the fields correctly", ->
      expect($scope.edit).toBe(false)
    it "should set all of the fields correctly", ->
      expect($scope.new_value).toEqual({})
    it "should set all of the fields correctly", ->
      expect($scope.changed).toBe(false)

  describe 'show init', ->
    beforeEach ->
      $scope.showInit(3)
    it "should correctly set the values", ->
      expect($scope.show).toBe(true)
    it "should correctly set the values", ->
      expect($scope.pricing.id).toBe(3)

  it "getKeys() should return the correct keys", ->
    pending "disabled"
    object = {"max_temperature":{}, "client":{}, "id":3, 'mud_type':{}}
    expect($scope.getKeys(object)).toEqual(["max_temperature"])

  describe "getNumericKeys() ", ->
    it "should return the correct results", ->
      expect($scope.numericKeys({"123a":123,"abc":"abc"})).toEqual([])
