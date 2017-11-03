Erdos.filter('currentReportFilter', () ->
  (reports) ->
    results = []
    if( reports )
      map = {}
      for report in reports
        map[report.report_type] = report
      for k in Object.keys(map)
        results.push map[k]
    results
)
