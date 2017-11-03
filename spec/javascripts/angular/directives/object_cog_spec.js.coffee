scope = undefined;
$rootScope = undefined;
$compile = undefined;
elem = undefined;

describe 'objectCog', ->

  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$compile_, _$rootScope_) ->
    scope = _$rootScope_.$new()
    scope.tmp = { id: 1 }
    scope.tmps = [ scope.tmp ]
    scope.$apply()
    $compile = _$compile_;
    elem = $compile( "<object-cog object='tmp'></object-cog>" )(scope)
    scope.$digest();
  )

  it 'should set details to true', ->
    for anchor in elem.find( 'a' )
      if anchor.id == '#details'
        anchor.click()
    expect( elem.scope().tmp.details ).toBe( true )
