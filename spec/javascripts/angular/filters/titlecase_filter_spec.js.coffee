describe 'titlecase filter', ->
  beforeEach( module( 'erdos' ) )

  describe 'titlecase', ->
    it 'should titlize correctly', inject (titlecaseFilter) ->
      expect( titlecaseFilter( "max_temperature" ) ).toEqual( 'Max Temperature' )