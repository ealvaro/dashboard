Erdos.directive "eventDetails", () ->
  restrict: 'AEC'
  replace: true
  templateUrl: "event_details.html.erb"
  scope:
    event: "="
    events: "="
  controller: ($scope) ->
    $scope.hasConfigs = false
    $scope.configs = {}
    $scope.gvConfigsOneDigit = {}
    $scope.gvConfigsTwoDigit = {}
    $scope.sifConfigsOneDigit = {}
    $scope.sifConfigsTwoDigit = {}

    renderConfigs = (pattern) ->
      obj = {}
      if pattern?
        re = new RegExp(pattern)
        for config_key in _.keys($scope.event.configs)
          if re.test(config_key)
            obj[config_key] = $scope.event.configs[config_key]
      else
        for configKey in _.keys($scope.event.configs)
          if configKey.indexOf("sif_bin") == -1 && configKey.indexOf("gv_") == -1
            obj[configKey] = $scope.event.configs[configKey]
      obj

    $scope.$watch 'event', ->
      $scope.hasConfigs = $scope.event.configs && Object.keys $scope.event.configs
      if $scope.hasConfigs
        $scope.configs = renderConfigs()
        $scope.gvConfigsOneDigit = renderConfigs("^gv_\\d{1}$")
        $scope.gvConfigsTwoDigit = renderConfigs("^gv_\\d{2}$")
        $scope.sifConfigsOneDigit = renderConfigs("^sif_bin_\\d{1}$")
        $scope.sifConfigsTwoDigit = renderConfigs("^sif_bin_\\d{2}$")

    $scope.parseDate = (date) ->
      Date.parse(date)

    $scope.hide = (eventDetails) ->
      eventDetails.details = false

    $scope.getMemoryUsageLevel = (event) ->
      if event.memory_usage_level
        event.memory_usage_level + '%'
      else
        undefined
