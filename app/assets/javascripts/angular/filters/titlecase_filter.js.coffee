Erdos.filter('titlecase', () ->
  (string) ->
    return string unless string
    result = ""
    for word in string.split("_")
      result += " " unless result == ""
      result += word.charAt(0).toUpperCase() + word.substr(1)
    result
)
