jQuery ->
  root = if $('#survey_import_form_job_id').length
           "#survey_import_form_"
         else
           "#survey_"

  $( root + 'job_id' ).change (data, fn) ->
    job_id = $(this).val()

    $(root + 'run_id').children().remove()

    auth_token = $('meta[name=auth-token]').attr("content")
    jQuery.ajax {
      url:'/push/jobs/' + job_id.toString(),
      headers:{"X-Auth-Token": auth_token}
      success: (job) ->
        select = $( root + 'run_id')
        for run in job.runs
          select.append(new Option(run.number, run.id))
    }
