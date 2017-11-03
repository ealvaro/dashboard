describe "install", ->
  $scope = undefined
  ctrl = undefined

  beforeEach module( "erdos" )
  beforeEach inject( (_$httpBackend_, _$rootScope_, $controller, $filter) ->
    $httpBackend = _$httpBackend_
    $scope = _$rootScope_.$new();
    ctrl = $controller( "InstallsController", { $scope, $filter } )
    $httpBackend.whenGET("/push/current_user").respond( {} )
    $scope.$apply()
  )

  describe 'initialize', ->
    it "should set filter type to 'LConfig'", ->
      expect( $scope.filterType ).toEqual( 'LConfig' )

  it "set types should populate types", ->
    $scope.setTypes( [{ application_name: "LConfig" }, { application_name: "LConfig" }] )
    expect( $scope.types ).toEqual( ["LConfig"] )

  it "set filter type should populate filter type", ->
    $scope.setFilterType( "LConfig" )
    expect( $scope.filterType ).toEqual( "LConfig" )

  describe "type count", ->
    it "type count should return zero on initialize", ->
      expect( $scope.typeCount( 'LConfig' ) ).toBe( 0 )
    it "type count should return the number of that type in installs", ->
      $scope.installs = [{ application_name: "LConfig" }, { application_name: "Universal Tester" }]
      expect( $scope.typeCount( 'LConfig' ) ).toBe( 1 )

  it "should set loading to true on initialize", ->
    expect( $scope.loading ).toBe( true )
