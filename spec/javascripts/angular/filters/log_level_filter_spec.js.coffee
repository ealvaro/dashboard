error = update_type:"ERROR"
note = update_type: "NOTE"
finished= update_type: "FINISHED"

describe 'Log level filter', ->
  beforeEach( module( 'erdos' ) )

  describe 'filter', ->
    it 'should return empty array if it gets passed undefined', inject (logLevelFilter) ->
      expect( logLevelFilter( undefined, "ERROR" ) ).toEqual( [] )

    describe 'when the log level is error',->
      it 'should return the error', inject (logLevelFilter) ->
        expect( logLevelFilter([error], "ERROR") ).toEqual([error])

      it 'should not return the note', inject (logLevelFilter) ->
        expect( logLevelFilter([note], "ERROR") ).toEqual([])

      it 'should not return finished', inject (logLevelFilter) ->
        expect( logLevelFilter([finished], "ERROR") ).toEqual([finished])

    describe 'when the log level is verbose',->
      it 'should return the error', inject (logLevelFilter) ->
        expect( logLevelFilter([error], "VERBOSE") ).toEqual([error])

      it 'should not return the note', inject (logLevelFilter) ->
        expect( logLevelFilter([note], "VERBOSE") ).toEqual([note])

      it 'should not return finished', inject (logLevelFilter) ->
        expect( logLevelFilter([finished], "VERBOSE") ).toEqual([finished])
