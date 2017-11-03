jQuery ->
  $(document).ready( ->
    if $("#mandate_health_algorithm").val() == "dgha"
      $("#health-parameters-type").show()
  )
  $('#datetimepicker1').datetimepicker(
    defaultDate: false
    format: 'YYYY/MM/DD LT'
  )

  $("#mandate_version").each () ->

    showVersionForm = (version) ->

      if version == ""
        $("#pulser-version-0").show()
        $("#pulser-version-2").hide()
        $("#pulser-version-1").hide()
      else
        $("#pulser-version-0").hide()
      if version == "1"
        $("#pulser-version-2").hide()
        $("#pulser-version-1").show()
      else
        if version == "2"
          $("#pulser-version-1").hide()
          $("#pulser-version-2").show()

    showVersionForm($(this).val())

    $(this).change () ->
      showVersionForm($(this).val())

  $("#mandate_health_algorithm").each () ->
    showAlgorithmForm = (selection) ->
      if selection == "" || selection == "threshold_algorithm"
        $("#health-parameters-type").hide()
      else
        $("#health-parameters-type").show()

    $(this).change () ->
      showAlgorithmForm($(this).val())



  $("#mandate-form").submit () ->
    # Remove the other version's inputs from being submitted to Rails. Otherwise the common fields overwrite each other.
    $mandate_version_select = $("#mandate_version")
    # Check if pulser Mandate form
    if $("#mandate_health_algorithm").val() != "dgha"
      $("#health-parameters-type").remove()
    if $mandate_version_select.length > 0
      version = $mandate_version_select.val()
      if version == "1"
        $("#pulser-version-2").remove()
      else
        $("#pulser-version-1").remove()
