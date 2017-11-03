scope = undefined

describe 'erdosReceiverPulseChart', ->
  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$rootScope_, _$compile_) ->
    scope = _$rootScope_
    element = '<erdos-receiver-pulse-chart></erdos-receiver-pulse-chart>'
    template = _$compile_(element)(scope)
    scope.$apply()
    scope = template.isolateScope()
  )

  it 'should not decompress if already array', ->
    data = []
    expect(scope.isCompressed(data)).toBe(data)

  it 'should decompress if object', ->
    data = {
      "time_stamp": 1441256822062,
      "sample_rate": 153,
      "values": [0, 1]
    }
    expect(scope.isCompressed(data)).not.toBe(data)

  it 'should correctly decompress', ->
    data = {
      "time_stamp": 1441256822062,
      "sample_rate": 153,
      "values": [0, 1]
    }
    time_stamp = scope.decompressPulseData(data)[1].time_stamp
    expect(time_stamp).toBe(1441256822068)