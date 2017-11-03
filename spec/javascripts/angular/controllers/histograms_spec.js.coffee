describe "histograms controller", ->
  $scope = undefined
  ctrl = undefined

  beforeEach module( "erdos" )
  beforeEach inject( (_$rootScope_, $controller) ->
    $scope = _$rootScope_.$new();
    ctrl = $controller( "HistogramsController", { $scope, $scope } )
    $scope.data = {}
    $scope.data.legend = [
      {title: "PD Axial", color: "#3498db"},
      {title: "PD Radial", color: "#2ecc71"},
      {title: "SI Axial", color: "#f1c40f"},
      {title: "SI Radial", color: "#e67e22"},
      {title: "Average", color: "#34495e"}
    ]
    $scope.data.job = '{ "id": 1, "name": "AB-123456" }'
    $scope.data.run = '{ "id": 1, "number": 1 }'
    $scope.data.jobs = [{ "id": 1, "name": "AB-123456" }]
  )

  it 'should be able to deep clone histograms', ->
    $scope.data.histograms = [
        { job_id: 1, run_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } },
        { job_id: 2, run_id: 1, data: { shock: { pd_axial: { "0-10": 2 } } } }
      ]
    expect($scope.histogramsCopy()).not.toBe($scope.data.histograms)
    expect($scope.histogramsCopy()).toEqual($scope.data.histograms)

  it 'should correctly humanize label', ->
    expect($scope.humanizeLabel("pd_axial")).toBe("PD Axial")
    expect($scope.humanizeLabel("average")).toBe("Average")

  it 'should correctly humanize labels', ->
    data = { shock: [ { range: "0-10", pd_axial: 1 } ] }
    expected = { Shock: [ { Range: "0-10", "PD Axial": 1 } ] }
    expect($scope.humanizeLabels(data)).toEqual(expected)

  it 'should correctly format histograms', ->
    data = { shock: { "0-10": { range: "0-10", pd_axial: 1 } } }
    expected = { shock: [ { range: "0-10", pd_axial: 1 } ] }
    expect($scope.formatHistograms(data)).toEqual(expected)

  it 'should correctly accumulate histograms', ->
    data = [
             { job_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } },
             { job_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } }
           ]
    expect($scope.accumulateHistograms(data).shock["0-10"]["pd_axial AB-123456"]).toEqual(2)

  it 'should correctly calculate average', ->
    data = { Range: "0-10", "PD Axial": 1, "PD Radial": 4 }
    expected = { Average: 2.5 }
    expect($scope.average(data)).toEqual(expected)

  it 'should correctly extend average', ->
    data = {shock: [{ Range: "0-10", "pd_axial AB-123456": 1, "pd_radial CD-234567": 3 }]}
    expected = _.extend(data, { Average: 2 })
    expect($scope.addAverages(data)).toEqual(expected)

  it 'should correctly filter histograms', ->
    histograms = [
        { job_id: 1, run_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } },
        { job_id: 1, run_id: 2, data: { shock: { pd_axial: { "0-10": 2 } } } },
        { job_id: 2, run_id: 1, data: { shock: { pd_axial: { "0-10": 2 } } } },
        { job_id: 2, run_id: 2, data: { shock: { pd_axial: { "0-10": 2 } } } }
      ]
    expected = histograms.slice(0, 2)
    expect($scope.filterHistograms(histograms, job_id: 1)).toEqual(expected)
    expected = histograms.slice(2, 4)
    expect($scope.filterHistograms(histograms, job_id: 2)).toEqual(expected)
    expected = histograms.slice(0, 1)
    expect($scope.filterHistograms(histograms, job_id: 1, run_id: 1)).toEqual(expected)

  it 'should correctly filter histograms by job', ->
    $scope.data.histograms = [
       { job_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } },
       { job_id: 2, data: { shock: { pd_axial: { "0-10": 2 } } } }
      ]
    expected = { Shock: [ { Range: '0-10', "pd_axial AB-123456": 1, Average: 1, "PD Axial": 1 } ] }
    expect($scope.filterJob()).toEqual(expected)

  it 'should correctly filter histograms by run', ->
    $scope.data.histograms = [
       { job_id: 1, run_id: 1, data: { shock: { pd_axial: { "0-10": 1 } } } },
       { job_id: 1, run_id: 2, data: { shock: { pd_axial: { "0-10": 2 } } } }
      ]
    expected = { Shock: [ { Range: '0-10', "pd_axial AB-123456": 1, Average: 1, "PD Axial": 1 } ] }
    expect($scope.filterRun()).toEqual(expected)

  it 'should be able to get job name', ->
    expect($scope.getJobName(1)).toBe($scope.data.jobs[0].name)

  it 'should add subtype totals', ->
    data = { Shock: [ { Range: "0-10", "pd_axial AB-123456": 1, "pd_axial CD-123456": 1 } ] }
    expect($scope.addSubtypeTotals(data)["Shock"][0]["PD Axial"]).toBe(2)