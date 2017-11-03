Erdos.controller "NotifiersController", ($scope, $timeout, $http) ->
  $scope.init = (canEditGroup, canDeleteGroup, user_id) ->
    $scope.tab = "Global"
    $scope.rigTab = 'Active'
    $scope.template = {}
    $scope.newAlertText = $scope.tab
    $scope.canEditGroup = canEditGroup
    $scope.canDeleteGroup = canDeleteGroup
    $scope.user_id = user_id
    setTitle "New"
    fetchData()

  $scope.refreshTab = ->
    currentTab = $scope.tab
    if $scope.currentTab == 'Global'
      $scope.changeTab('Rig').then ->
        $scope.changeTab(currentTab)
    else
      $scope.changeTab('Global').then ->
        $scope.changeTab(currentTab)

  $scope.changeTab = (tab) ->
    $scope.tab = tab
    $scope.new = false
    $scope.newNotifier = false
    $scope.newTemplate = false
    $scope.editTemp = false
    $scope.newGroup = false
    $scope.editGroup = false
    $scope.importTemplate = false
    $scope.newAlertText = $scope.tab
    fetchData()

  $scope.changeTemplate = (template) ->
    $scope.template = template

  $scope.newClicked = ->
    $scope.new = true
    setTitle "New"
    $timeout ->
      $scope.$broadcast 'new-notifier'

  $scope.$on "edit-notifier", (evt, notifier) ->
    setTitle "Edit"
    if notifier?
      $scope.new = true
      $scope.newNotifier = true
      $timeout ->
        $scope.$broadcast 'update-notifier', notifier

  fetchData = ->
    if $scope.tab == 'Rig'
      fetchRigs().then ->
        if $scope.rigs.length > 0
          $scope.rig = $scope.rigs[0]
          fetchRigNotifiers()
        else
          $scope.notifiers = []
        $scope.newAlertText = $scope.rig.name
    else if $scope.tab == 'Group'
      fetchRigGroups()
    else if $scope.tab == 'User Template'
      fetchTemplates().then ->
        if $scope.templates.length > 0
          $scope.template = $scope.templates[0]
          fetchTemplateNotifiers()
        else
          $scope.notifiers = []
        $scope.newAlertText = $scope.template.name
    else
      fetchGlobalNotifiers()

  fetchGlobalNotifiers = ->
    $http.get('/global_notifiers').then (response) ->
      $scope.notifiers = response.data || []

  fetchGroupNotifiers = ->
    $http.get('/group_notifiers', params: { group: $scope.rigGroup.id }).then (response) ->
      $scope.notifiers = response.data || []

  fetchRigNotifiers = ->
    $http.get('/rig_notifiers', params: { rig_name: $scope.rig.name }).then (response) ->
      $scope.notifiers = response.data || []

  fetchRigGroups = ->
    $http.get('/rig_groups/').then (response) ->
      $scope.rigGroups = response.data || []
      if $scope.rigGroups.length > 0
        $scope.rigGroup = $scope.rigGroups[0]
        fetchGroupNotifiers()

  fetchTemplates = ->
    $http.get('/templates').then (response) ->
      $scope.templates = response.data || []

  fetchTemplateNotifiers = ->
    $http.get('/template_notifiers', params: { template_id: $scope.template.id }).then (response) ->
      $scope.notifiers = response.data || []

  $scope.deleteGroup = (rigGroup)->
    if confirm( "Are you sure you want to delete this Rig Group? This operation is irreversible." ) == true
      id = rigGroup.id
      $http.delete("/rig_groups/#{id}").then (response) ->
        $scope.refreshTab()

  $scope.deleteTemplate = (template) ->
    if confirm( "Are you sure you want to delete this Template? This operation is irreversible." ) == true
      $http.delete("/templates/#{template.id}").then (response) ->
        $scope.refreshTab()

  $scope.cloneTemplate = (template) ->
    name = window.prompt("Template Name:", "#{template.name} clone")
    $http.post("/templates/#{template.id}/clone", template: { name: name }).then (response) ->
      $scope.refreshTab()

  $scope.changeRigTab = (tab) ->
    $scope.rigTab = tab

  $scope.changeRigGroup = (rigGroup) ->
    $scope.rigGroup = rigGroup
    fetchGroupNotifiers()

  $scope.changeRig = (rig) ->
    $scope.rig = rig
    fetchRigNotifiers()

  fetchRigs = ->
    if $scope.rigTab == 'All'
      fetchAllRigs()
    else
      fetchActiveRigs()

  fetchActiveRigs = ->
    $http.get('/rigs/active')
      .then (response) ->
        if response.data.length == 0
          fetchAllRigs()
        else
          $scope.rigs = response.data

  fetchAllRigs = ->
    $http.get('/rigs')
      .then (response) ->
        $scope.rigs = response.data

  $scope.createTemplate = ->
    $scope.newTemplate = true

  $scope.editTemplate = (template) ->
    $scope.changeTemplate(template)
    $scope.editTemp = true
    $scope.newTemplate = true

  $scope.newGroupClicked = ->
    $scope.rigGroup = {}
    $scope.newGroup = true

  $scope.editGroupClicked = (rigGroup) ->
    $scope.rigGroup = rigGroup
    $scope.newGroup = true
    $scope.editGroup = true

  $scope.importTemplateClicked = ->
    $scope.importTemplate = true

  $scope.createNotifier = ->
    $scope.newNotifier = true

  $scope.$watch 'rigTab', ->
    if $scope.tab == 'Rig' || 'Group'
      fetchRigs()

  $scope.$watch 'template', ->
    if $scope.tab == 'User Template'
      fetchTemplateNotifiers()

  setTitle = (method) ->
    $scope.title = "#{method} #{$scope.newAlertText} Alert"