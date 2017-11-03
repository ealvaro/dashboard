describe 'PumpTime filter', ->
  beforeEach( module( 'erdos' ) )

  describe 'pumpTime', ->
    it 'should format 36000 sec to 10:00:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 36000 * 1000 ) ).toEqual( '10:00:00' )

    it 'should format 19800 sec to 05:30:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 19800 * 1000 ) ).toEqual( '05:30:00' )

    it 'should format 3600 sec to 01:00:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 3600 * 1000 ) ).toEqual( '01:00:00' )

    it 'should format 1800 sec to 00:30:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 1800 * 1000 ) ).toEqual( '00:30:00' )

    it 'should format 60 sec to 00:01:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 60 * 1000 ) ).toEqual( '00:01:00' )

    it 'should format 30 sec to 00:00:30', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 30 * 1000 ) ).toEqual( '00:00:30' )

    it 'should format 0 to 00:00:00', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter( 0 ) ).toEqual( '00:00:00' )

    it 'should format undefined to null', inject (pumpTimeFilter) ->
      expect( pumpTimeFilter(  ) ).toEqual(  )
