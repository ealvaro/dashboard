describe 'UID filter', ->
  beforeEach( module( 'erdos' ) )

  describe 'uid', ->
    it 'should format a uid', inject (uidFilter) ->
      expect( uidFilter( "1234567890123456" ) ).toEqual( '12:34:56:78:90:12:34:56' )
      
    it 'should format a short uid', inject (uidFilter) ->
      expect( uidFilter( "12345678" ) ).toEqual( '12:34:56:78' )

    it 'should ', inject (uidFilter) ->
      expect( uidFilter( undefined ) ).toEqual( '' )
