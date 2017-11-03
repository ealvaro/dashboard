ReplaceFeedback = =>
  $("a#atlwdg-trigger").hide()
  $("#feedback-button").replaceWith( ->
    $("a#atlwdg-trigger").removeClass("atlwdg-trigger")
  )
  supportLink = '<span class="icon zmdi-headset-mic"></span>'
  $("a#atlwdg-trigger").html(supportLink)
  $("a#atlwdg-trigger").show()

if $('html').hasClass('lt-ie10')
  $ ->
    $("a#atlwdg-trigger").hide()
    setTimeout (->
      ReplaceFeedback()
      return
    ), 500
else
  $(window).bind "load", ->
    ReplaceFeedback()
