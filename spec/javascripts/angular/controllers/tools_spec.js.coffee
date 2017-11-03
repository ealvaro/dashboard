describe "tools", ->
  $scope = undefined
  ctrl = undefined

  beforeEach module( "erdos" )
  beforeEach inject( (_$rootScope_, $controller) ->
    $scope = _$rootScope_.$new();
    ctrl = $controller( "ToolsController", { $scope, $scope } )
  )

  describe 'initialize', ->
    it 'should set show_tools to be true', ->
      expect( $scope.show_tools ).toBe( true )

    it 'should set show memories to be false', ->
      expect( $scope.show_memories ).toBe( false )

  describe 'show tab', ->
    it 'should set show memories correctly', ->
      $scope.showTab( 'memories' )
      expect( $scope.show_tools ).toBe( false )
      expect( $scope.show_memories ).toBe( true )

    it 'should set show memories correctly', ->
      $scope.showTab( 'memories' )
      expect( $scope.show_tools ).toBe( false )
      expect( $scope.show_memories ).toBe( true )
      $scope.showTab( 'tools' )
      expect( $scope.show_tools ).toBe( true )
      expect( $scope.show_memories ).toBe( false )
