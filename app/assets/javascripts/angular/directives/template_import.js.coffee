Erdos.directive "templateImport", ($http) ->
  restrict: 'E'
  replace: true
  scope: false
  templateUrl: "template_import.html"
  controller: ($scope) ->
    $scope.data = {}

    loadUsers = ->
      if $scope.data.filter == 'All Users'
        $http.get('/push/users/').then (response) ->
          $scope.data.users = response.data
      else
        $http.get('/push/users/alert_users').then (response) ->
          if response.data.length > 0
            $scope.data.users = response.data
          else
            $scope.data.filter = 'All Users'

    loadTemplates = ->
      user_id = $scope.data.selectedUserId
      $http.get("/templates/?user_id=#{user_id}").then (response) ->
        $scope.data.templates = response.data || []
        if $scope.data.templates.length == 0
          $scope.data.templates = [{id: -1, name: "(None available)"}]

        $scope.data.selectedTemplateId = $scope.data.templates[0].id

    $scope.init = ->
      $scope.data =
        filter: 'Active Users'
        users: []
        templates: []

    $scope.submit = ->
      id = $scope.data.selectedTemplateId
      user_id = $scope.data.selectedUserId
      if id? > 0 and user_id?
        $http.post("/templates/#{id}/import").then (response) ->
          $scope.refreshTab()

    $scope.cancel = ->
      $scope.refreshTab()

    $scope.$watch 'data.filter', ->
      loadUsers()

    $scope.$watch 'data.users', ->
      found = _.find $scope.data.users, (user) ->
        $scope.data.selectedUserId == user.id
      if not found && $scope.data.users.length > 0
        $scope.data.selectedUserId = $scope.data.users[0].id

    $scope.$watch 'data.selectedUserId', ->
      if $scope.data.selectedUserId?
        loadTemplates()
