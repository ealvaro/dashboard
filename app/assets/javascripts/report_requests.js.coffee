toggleBackground = (id) ->
  if $("##{id}").hasClass('primary-bisque-bg')
    $("##{id}").addClass('primary-blue-bg')
    $("##{id}").removeClass('primary-bisque-bg')
  else
    $("##{id}").addClass('primary-bisque-bg')
    $("##{id}").removeClass('primary-blue-bg')

toggleShow = (klass) ->
  if $('.' + klass).css('display') == 'none'
      $('.' + klass).show()
  else
      $('.' + klass).hide()

$(document).ready ->
  if $('#new_report_request_job').length
    if not $("#report_request_request_survey").attr('checked')
      toggleShow 'report-requests-survey'

    if not $("#report_request_request_reports").attr('checked')
      toggleShow 'report-requests-reports'
      $('')

  if $('#show_report_request_survey').length
    $(".form-control").attr "readonly", true
    $(":checkbox").attr "disabled", true

exports = this
exports.toggleShow = toggleShow
exports.toggleBackground = toggleBackground