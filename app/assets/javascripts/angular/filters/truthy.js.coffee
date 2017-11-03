emFormatTruthy = (value) ->
  if value then "TRUE" else "FALSE"

Erdos.filter 'truthy', ->
  emFormatTruthy

exports = this
exports.emFormatTruthy = emFormatTruthy
