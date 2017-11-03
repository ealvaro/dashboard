Erdos.directive "notifierForm", ->
  restrict: 'E'
  replace: true
  templateUrl: "notifier_form.html.erb"
  controller: ($scope, $timeout, Notifier) ->
    update_fields = ->
      $timeout ->
        $scope.$broadcast 'update-fields', $scope.fields

    empty_condition = ->
      type: "condition"
      placeholder: "Enter value"
      update: ""
      field: ""
      operator: ""
      value: ""
      textValue: ""
      selectValue: ""
      valueOp: ""

    empty_grouping = ->
      type: "grouping"
      boolean: "and"
      conditions: [empty_condition()]

    insert_grouping = (conditions, index) ->
      conditions.splice index, 0, empty_grouping()
      update_fields()

    insert_condition = (conditions, index) ->
      conditions.splice index, 0, empty_condition()
      update_fields()

    set_default_notifier = ->
      $scope.notifier =
        name: ''
        configuration: empty_grouping()

    $scope.add_condition = (conditions, index) ->
      insert_condition conditions, index + 1

    $scope.add_grouping = (conditions, index) ->
      insert_grouping conditions, index + 1

    $scope.remove = (conditions, index, surconditions, surindex) ->
      if conditions.length == 1 and surconditions? and surindex >= 0
        surconditions.splice surindex, 1
      else if conditions.length > 1
        conditions.splice index, 1

    $scope.create = ->
      $scope.notifierForm.submitted = true
      if ($scope.notifierForm.$valid)
        mergeAssociatedData()
        if $scope.tab == 'Global'
          Notifier.createGlobal($scope.notifier).then (response) ->
            $scope.refreshTab()
        else if $scope.tab == 'Group'
          Notifier.createGroup($scope.notifier).then (response) ->
          $scope.refreshTab()
        else if $scope.tab == 'Rig'
          Notifier.createRig($scope.notifier).then (response) ->
            $scope.refreshTab()
        else if $scope.tab == 'User Template'
          Notifier.createTemplate($scope.notifier).then (response) ->
            $scope.refreshTab()

    $scope.save = ->
      $scope.notifierForm.submitted = true
      if ($scope.notifierForm.$valid)
        Notifier.save($scope.notifier).success((data) ->
          $scope.refreshTab()
        )

    $scope.cancel = ->
      $scope.refreshTab()

    index = 0
    $scope.uniquify = ->
      index += 1

    $scope.showRequired = (name) ->
      required = false
      if $scope.notifierForm.name?
        required = $scope.notifierForm.name.$invalid && $scope.notifierForm.submitted

      required

    Notifier.updates_fields (response) ->
      $scope.fields = response
      update_fields()

    setSubmission = (method) ->
      $scope.submitText = "#{method} #{$scope.tab} Alert"
      $scope.submitFunction = (method == "Update" && $scope.save) || $scope.create

    $scope.init = ->
      set_default_notifier()
      update_fields()
      setSubmission "Create New"

    $scope.data =
      matcherSelect:
        options: [
          {name: "ALL", value: "and"},
          {name: "ANY", value: "or"}]

    mergeAssociatedData = ->
      if $scope.tab == 'Rig'
        data = { rig_id: $scope.rig.id }
      else if $scope.tab == 'Group'
        data = { group_id: $scope.rigGroup.id }
      else if $scope.tab == 'User Template'
        data = { template_id: $scope.template.id }
      else
        data = null
      jQuery.extend($scope.notifier, { associated_data: data })

    $scope.$on "new-notifier", (evt, notifier) ->
      $scope.init()

    $scope.$on "update-notifier", (evt, notifier) ->
      $scope.notifier = notifier
      setSubmission "Update"
