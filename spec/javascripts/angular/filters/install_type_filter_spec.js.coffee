describe 'Install type filter', ->
  beforeEach( module( 'erdos' ) )

  describe 'filter', ->
    it 'should return empty array if it gets passed undefined', inject (installTypeFilter) ->
      expect( installTypeFilter( undefined, 'LConfig' ) ).toEqual( [] )

    it 'should return empty array if it gets passed an empty array', inject (installTypeFilter) ->
      expect( installTypeFilter( [], 'LConfig' ) ).toEqual( [] )

    it 'should filter on application_name', inject (installTypeFilter) ->
      array= [{ application_name: 'LConfig' }]
      expect( installTypeFilter( array, 'LConfig' ) ).toEqual( array )

    it 'should filter on application_name', inject (installTypeFilter) ->
      array= [{ application_name: 'Wacky' }]
      expect( installTypeFilter( array, 'LConfig' ) ).toEqual( [] )
