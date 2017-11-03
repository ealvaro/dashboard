emFormatNumber = (number, fractionSize) ->
  # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/round
  return "" if not number?

  fractionSize = 2 if not fractionSize?

  s = "#{Math.round(+('' + number + 'e' + fractionSize))}"
  +(s + 'e' + -fractionSize)

addZeroIfNeeded = (value) ->
  value = "0" + value if value < 10
  value

emFormatDate = (date) ->
  return "" if not date?
  d = new Date(date)
  year = d.getFullYear()
  month = addZeroIfNeeded d.getMonth() + 1
  day = addZeroIfNeeded d.getDay()

  hour = addZeroIfNeeded d.getHours()
  minute = addZeroIfNeeded d.getMinutes()
  second = addZeroIfNeeded d.getSeconds()

  "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"

exports = this
exports.emFormatDate = emFormatDate
exports.emFormatNumber = emFormatNumber
