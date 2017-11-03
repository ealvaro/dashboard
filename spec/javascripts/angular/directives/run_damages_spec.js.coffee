$scope = undefined;
scope = undefined;
$rootScope = undefined;
$compile = undefined;
$httpBackend = undefined;
elem = undefined;
$http = undefined
run =
  damages_as_billed: []
invoice =
  multiplier_as_billed: 1



describe 'run damages directive', ->

  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$httpBackend_, _$compile_, _$rootScope_) ->
    $httpBackend = _$httpBackend_
    $scope = _$rootScope_.$new()
    $compile = _$compile_;
    $scope.run = run
    $scope.invoice = invoice
    elem = $compile( "<run-damages run='run' invoice='invoice'></run-damages>" )($scope)
    scope = elem.scope()
    scope.$apply();
  )

  describe 'recalculate', ->
    describe 'when damages are empty', ->
      beforeEach ->
        scope.run.damages_as_billed = {}
        scope.$apply()
      it 'should return 0', ->
        expect( scope.run.damages_as_billed.subtotal ).toBe( 0 )

    describe 'when damages are not empty', ->
      beforeEach ->
        scope.run.damages_as_billed = {}
        scope.run.damages_as_billed.max_temperature = { "amount": 1000 }
        scope.run.damages_as_billed.max_shock = { "amount": 1000 }
        scope.$apply()
      it 'should return the sum of the amounts', ->
        expect( scope.run.damages_as_billed.subtotal ).toBe( 2000 )