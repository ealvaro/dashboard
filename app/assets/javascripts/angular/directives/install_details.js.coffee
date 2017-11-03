Erdos.directive "installDetails", ($http) ->
  restrict: 'AEC'
  replace: true
  templateUrl: "install_details.html.erb"
  scope:
    install: "="
    installs: "="
  controller: ($scope) ->
    $scope.parseDate = ( date ) ->
      Date.parse( date )

    $scope.hide = (installDetails) ->
      installDetails.details = false

    $scope.$watch 'install', ->
      if $scope.install.details && !$scope.tools
        $scope.fetchToolData()

    $scope.fetchToolData = ->
      $http({method: "GET", url: "/push/installs/#{$scope.install.key}/recent_tools" }).success (response) ->
        $scope.tools = response

    $scope.getDate = (object, attr) ->
      if object && object[attr]
        moment( Date.parse( object[attr] ) )
      else
        undefined
