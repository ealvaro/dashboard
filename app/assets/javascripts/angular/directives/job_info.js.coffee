Erdos.directive "jobInfo", () ->
  restrict: 'E'
  replace: true
  templateUrl: "job_info.html.erb"
  scope:
    job: '='
