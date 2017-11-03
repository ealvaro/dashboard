Erdos.controller "NotifiersFormController", ($scope, $timeout, Notifier) ->
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
    boolean: ""
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
      Notifier.create($scope.notifier).success (data) ->
        $scope.refreshTab()
    else
      $scope.listErrors()

  $scope.save = ->
    $scope.notifierForm.submitted = true
    if ($scope.notifierForm.$valid)
      Notifier.save($scope.notifier).success((data) ->
        $scope.refreshTab()
      )
    else
      $scope.listErrors()

  $scope.cancel = ->
    $scope.refreshTab()

  index = 0
  $scope.uniquify = ->
    index += 1

  capitalize = (word) ->
    word[0].toUpperCase() + word.slice(1)

  displayName = (name) ->
    s = name.replace(/[0-9]/g, '').replace(/text-/g, '').replace(/select-/g, '')
    capitalize s

  $scope.formattedErrors = []

  $scope.listErrors = ->
    $scope.formattedErrors =
     _.uniq _.map(angular.element($(".alert-control.ng-invalid-required")), (e) ->
        displayName(e.name) + " must be filled in"
      )

  $scope.showRequired = (name) ->
    required = false
    if $scope.notifierForm.name?
      required = $scope.notifierForm.name.$invalid && $scope.notifierForm.submitted

    required

  Notifier.updates_fields (response) ->
    $scope.fields = response
    update_fields()

  $scope.init = (json) ->
    notifier = JSON.parse(json)
    if _.isEmpty(notifier)
      set_default_notifier()
    else
      $scope.notifier = notifier

    update_fields()

  $scope.data =
    matcherSelect:
      options: [
        {name: "ALL", value: "and"},
        {name: "ANY", value: "or"}]
