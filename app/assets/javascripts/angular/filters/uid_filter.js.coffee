emFormatUid = (uid) ->
  result = ""
  count = 0
  if uid
    for char in uid
      result += char
      if count % 2 && count != 0 && count != uid.length - 1
        result += ":"
      count += 1

  result

Erdos.filter 'uid', ->
  emFormatUid

exports = this
exports.emFormatUid = emFormatUid
