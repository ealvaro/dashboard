Erdos.directive "notifierCondition", ->
  restrict: 'E'
  replace: true
  scope:
    condition: '='
    addCondition: '&'
    addGrouping: '&'
    remove: '&'
    uniquify: '&'
    showRequired: '&'
    canAddGroups: '@'
  templateUrl: "notifier_condition.html"
  controller: ($scope) ->
    $scope.update_name = "update" + $scope.uniquify()()
    $scope.field_name = "field" + $scope.uniquify()()
    $scope.condition_name = "condition" + $scope.uniquify()()
    $scope.operator_name = "operator" + $scope.uniquify()()
    $scope.text_value_name = "text-value" + $scope.uniquify()()
    $scope.select_value_name = "select-value" + $scope.uniquify()()
    $scope.value_op = "value-op" + $scope.uniquify()()

    $scope.$on "update-fields", (evt, data) ->
      if data?
        $scope.data.fieldSelect.options.receiver = data.receiver
        $scope.data.fieldSelect.options.logger = data.logger

    $scope.fieldOptions = ->
      options = $scope.data.fieldSelect.options
      switch $scope.condition.update
        when "LeamReceiverUpdate", "EmReceiverUpdate" then options.receiver
        when "BtrReceiverUpdate", "BtrControlUpdate" then options.receiver
        when "LoggerUpdate" then options.logger
        else []

    $scope.operatorOptions = ->
      # when adding anything new here, see allowed_operators
      if $scope.condition.field in $scope.string_fields
        [{name: "equal to", value: '=='},
         {name: "not equal to", value: '!='},
         {name: "contains", value: 'include?'},
         {name: "does not contain", value: 'exclude?'}]
      else if $scope.condition.field in $scope.value_select_fields
        [{name: "equal to", value: '=='},
         {name: "not equal to", value: '!='}]
      else
        [{name: "less than", value: '<'},
         {name: "equal to", value: '=='},
         {name: "not equal to", value: '!='},
         {name: "greater than", value: '>'}]

    $scope.showValueSelect = ->
      $scope.condition.field in $scope.value_select_fields

    $scope.valueOptions = ->
      if $scope.condition.field in $scope.yes_no_fields
        [{name: "Yes", value: 'Y'},
         {name: "No", value: 'N'}]
      else if $scope.condition.field in $scope.true_false_fields
        [{name: "True", value: 'true'},
         {name: "False", value: 'false'}]
      else if $scope.condition.field in $scope.on_off_fields
        [{name: "On", value: 'on'},
         {name: "Off", value: 'off'}]
      else
        []

    $scope.showValueOp = ->
      $scope.condition.field == "temperature"

    format_to_millis = (time) ->
      millis = 0

      if time?
        multiplier = 1000

        for v in time.split(":").reverse()
          millis += (parseInt(v) || 0) * multiplier

          multiplier *= 60
          break if multiplier > 1000 * 60 * 60

      "" + millis

    updateValue = ->
      if $scope.condition.field in $scope.value_select_fields
        $scope.condition.value = $scope.condition.selectValue
      else if $scope.condition.field in $scope.millisecond_fields
        $scope.condition.value = format_to_millis $scope.condition.textValue
      else
        $scope.condition.value = $scope.condition.textValue

    $scope.$watch 'condition.field', updateValue
    $scope.$watch 'condition.selectValue', updateValue
    $scope.$watch 'condition.textValue', updateValue

    $scope.data =
      updateTypeSelect:
        options: [
          {name: "Leam Receiver", value: 'LeamReceiverUpdate'},
          {name: "APS EM Receiver", value: 'EmReceiverUpdate'},
          {name: "BTR Monitor", value: 'BtrReceiverUpdate'},
          {name: "BTR Control", value: 'BtrControlUpdate'},
          {name: "Logger", value: 'LoggerUpdate'}]
      fieldSelect:
        options: {
          receiver: []
          logger: []}
      valueOpSelect:
        options: [
          {name: "F", value: 'F'},
          {name: "C", value: 'C'}]

    $scope.string_fields = ["job_number", "run_number", "rig_name", "well_name", "client_name", "team_viewer_id", "team_viewer_password", "reporter_version", "sync_marker"]
    $scope.yes_no_fields = ["pumps_on", "on_bottom", "slips_out"]
    $scope.true_false_fields = ["bat2", "batw", "dipw", "gravw", "magw", "tempw", "dl_enabled"]
    $scope.on_off_fields = ["pump_state"]
    $scope.value_select_fields = $scope.yes_no_fields.concat($scope.true_false_fields).concat($scope.on_off_fields)

    # see also backend millisecond_fields
    $scope.millisecond_fields = ["pump_on_time", "pump_off_time", "pump_total_time", "last_update"]
