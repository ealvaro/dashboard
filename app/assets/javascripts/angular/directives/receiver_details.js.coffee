Erdos.directive "receiverDetails", () ->
  restrict: 'AEC'
  replace: true
  templateUrl: "receiver_details.html.erb"
  scope:
    receiver: "="
  controller: ($scope) ->
    $scope.hide = (receiver) ->
      receiver.details = false

    $scope.getDate = (event, attr) ->
      if event && event[attr]
        moment( (new Date( event[attr] )).getTime() )
      else
        undefined
