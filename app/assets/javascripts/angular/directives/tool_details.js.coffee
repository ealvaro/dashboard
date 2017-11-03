Erdos.directive "toolDetails", () ->
  restrict: 'AEC'
  replace: true
  templateUrl: "tool_details.html.erb"
  scope:
    tool: "="
    show: "="
  controller: ($scope) ->
    $scope.parseDate = ( date ) ->
      Date.parse( date )

    $scope.hide = () ->
      $scope.tool.details = false

    $scope.isReceiver = (tool) ->
      names = ["Receiver", "BTR Control", "BTR Monitor", "LRx", "APS EM Rx"]
      tool.cache.tool_type_name in names
