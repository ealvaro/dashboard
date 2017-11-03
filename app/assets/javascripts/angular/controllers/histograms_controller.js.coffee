Erdos.controller "HistogramsController", ($scope) ->
  $scope.init = (tool, histograms, jobs, runs) ->
    $scope.data = {}
    $scope.data.omit = ["Range", "Subtype", "Average", "Total"]
    $scope.data.legend = [
      {title: "PD Axial", color: "#3498db"},
      {title: "PD Radial", color: "#2ecc71"},
      {title: "SI Axial", color: "#f1c40f"},
      {title: "SI Radial", color: "#e67e22"},
      {title: "Average", color: "#34495e"}
    ]
    $scope.data.tool = JSON.parse(tool) || {}
    $scope.data.histograms = JSON.parse(histograms) || {}
    $scope.data.jobs = JSON.parse(jobs) || []
    $scope.data.runs = JSON.parse(runs) || []
    $scope.graphHistograms($scope.histogramsCopy())
    $scope.data.types = _.keys($scope.filtered)
    $scope.tab = $scope.data.types[0]

  $scope.changeTab = (tab) ->
    $scope.tab = tab

  $scope.histogramsCopy = ->
    $scope.deepClone($scope.data.histograms)

  $scope.deepClone = (data) ->
    JSON.parse(JSON.stringify(data))

  $scope.filterHistograms = (histograms, filter={}) ->
    _.where(histograms, filter)

  $scope.filterJob = ->
    job = JSON.parse($scope.data.job) unless $scope.data.job == ""
    if job?
      $scope.data.run = ""
      $scope.runs = _.where($scope.data.runs, {job_id: job.id})
      histograms = $scope.filterHistograms($scope.histogramsCopy(), job_id: job.id)
      $scope.graphHistograms(histograms)
    else
      $scope.graphHistograms($scope.histogramsCopy())

  $scope.filterRun = ->
    job = JSON.parse($scope.data.job) unless $scope.data.job == ""
    run = JSON.parse($scope.data.run) unless $scope.data.run == ""
    if run?
      histograms = $scope.filterHistograms($scope.histogramsCopy(), job_id: job.id, run_id: run.id)
      $scope.graphHistograms(histograms)
    else
      $scope.graphHistograms($scope.histogramsCopy())

  capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.substring(1).toLowerCase()

  humanize = (label) ->
    label = label.split('_')
    for word, i in label
      if word.length == 2
        label[i] = word.toUpperCase()
      else
        label[i] = capitalize(word)
    label = label.join(' ')

  isJob = (label) ->
    label.indexOf('-') != -1

  # humanize key
  $scope.humanizeLabel = (label) ->
    index = label.indexOf('_')
    if index != -1
      label = humanize(label)
    else
      label = capitalize(label)
    label

  # humanize all keys
  $scope.humanizeLabels = (filtered) ->
    for type, type_data of filtered
      newLabel = $scope.humanizeLabel(type)
      filtered[newLabel] = filtered[type]
      for point in filtered[newLabel]
        for label, count of point
          unless isJob(label)
            newLabel = $scope.humanizeLabel(label)
            point[newLabel] = count
            delete point[label]
      delete filtered[type]
    filtered

  # format histograms for AMcharts
  $scope.formatHistograms = (histograms) ->
    filtered = {}
    for type of histograms
      filtered[type] = _.values(histograms[type])
    filtered

  # accumulate histogram counts
  $scope.accumulateHistograms = (histograms) ->
    temp = {}
    for histogram in histograms
      job_number = $scope.getJobName(histogram.job_id)
      for type, typeData of histogram.data
        temp[type] = {} if !temp[type]?
        if $scope.isNested(typeData)
          for subtype, subtypeData of typeData
            for range, count of subtypeData
              temp[type][range] = { range: range } if !temp[type][range]?
              if !temp[type][range]["#{subtype} #{job_number}"]?
                temp[type][range]["#{subtype} #{job_number}"] = count
              else
                temp[type][range]["#{subtype} #{job_number}"] += count
        else
          for range, count of typeData
            temp[type][range] = { range: range } if !temp[type][range]?
            if !temp[type][range][job_number]?
              temp[type][range][job_number] = count
            else
              temp[type][range][job_number] += count
    temp

  $scope.addSubtypeTotals = (filtered) ->
    for type of filtered
      for rangeHash in filtered[type]
        for key, value of rangeHash
          subtype = $scope.getSubtype(key)
          if type == 'Temperature'
            if !rangeHash.total?
              rangeHash["Total"] = value if _.isNumber(value)
            else
              rangeHash["Total"] += value if _.isNumber(value)
          else
            if !_.contains($scope.subtypes(), subtype)
              continue
            else
              if !rangeHash[subtype]?
                rangeHash[subtype] = value
              else
                rangeHash[subtype] += value
    filtered

  $scope.getJobName = (job_id) ->
    _.findWhere($scope.data.jobs, { id: job_id }).name

  $scope.graphHistograms = (histograms) ->
    accumulated = $scope.accumulateHistograms(histograms)
    filtered = $scope.formatHistograms(accumulated)
    humanized = $scope.humanizeLabels(filtered)
    totaled = $scope.addSubtypeTotals(humanized)
    $scope.filtered = $scope.addAverages(totaled)

  $scope.isNested = (object) ->
    _.isObject(_.values(object)[0])

  $scope.addAverages = (data) ->
    for type, typeData of data
      unless type == 'Temperature'
        for rangeHash in typeData
          _.extend(rangeHash, $scope.average(rangeHash))
    data

  $scope.subtypes = ->
    _.without(_.pluck($scope.data.legend, 'title'), "Average")

  $scope.average = (rangeHash) ->
    sum = 0.0
    picked = _.pick(rangeHash, $scope.subtypes())
    for subtype, value of picked
      sum += value
    { Average: (sum/_.keys(picked).length) }

  $scope.getSubtype = (key) ->
    split = key.split(' ')
    $scope.humanizeLabel(split[0])

  $scope.getJobNumber = (key) ->
    key.split(' ')[1]