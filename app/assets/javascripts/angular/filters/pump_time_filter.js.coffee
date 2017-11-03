emFormatPumpTime = (milliseconds) ->
  if milliseconds >= 0
    hours = Math.floor(milliseconds / (1000 * 60 * 60))
    milliseconds -= (hours * 1000 * 60 * 60)
    hours = "0" + hours.toString() if hours < 10
    minutes = Math.floor(milliseconds / (60 * 1000))
    milliseconds -= (minutes * 60 * 1000)
    minutes = "0" + minutes.toString() if minutes < 10
    seconds = Math.floor(milliseconds / 1000)
    seconds = "0" + seconds.toString() if seconds < 10
    "#{hours}:#{minutes}:#{seconds}"

Erdos.filter 'pumpTime', ->
  emFormatPumpTime

exports = this
exports.emFormatPumpTime = emFormatPumpTime
