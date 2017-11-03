$scope = undefined;
scope = undefined;
$rootScope = undefined;
$compile = undefined;
elem = undefined;

describe 'toolCog', ->

  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$compile_, _$rootScope_) ->
    $scope = _$rootScope_.$new()
    $scope.tool = { id: 1, uid: "123123123" }
    $scope.$apply()
    $compile = _$compile_;
    elem = $compile( angular.element("<tool-cog tool='tool'></tool-cog>" ))($scope)
    scope = elem.scope()
    scope.$apply();
  )

  xit 'should set the correct event type id', ->
    expect( scope.getId("In Service") ).toEqual(12)

  xit 'should set the correct event type id', ->
    expect( scope.getId("In Development") ).toEqual(13)

  xit 'should set the correct event type id', ->
    expect( scope.getId("In Repair") ).toEqual(14)

  xit 'should set the correct event type id', ->
    expect( scope.getId("Retired: Preemptive Replacement") ).toEqual(15)

  xit 'should set the correct event type id', ->
    expect( scope.getId("Retired: Down-hole Failure") ).toEqual(16)

  xit 'should set the correct event type id', ->
    expect( scope.getId("Retired: Shop Damage") ).toEqual(17)
