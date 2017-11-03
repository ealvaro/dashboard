Erdos.directive "invoiceForm", ($http, $window) ->
  restrict: 'E'
  replace: true
  templateUrl: "invoice_form.html.erb"
  scope:
    edit: '='
    invoice: '='
  controller: ($scope) ->
    $scope.submit = (status) ->
      $scope.invoice.date_of_issue = $('#date_of_issue')[0].value
      status = "draft" unless status
      $scope.invoice.total = $scope.invoiceTotal()
      if !$scope.submitted
        $scope.invoice.status = status
        method = "POST"
        url = '/push/invoices'
        if $scope.edit
          method = "PATCH"
          url = '/push/invoices/' + $scope.invoice.id.toString()
        $http( { method: method, url: url, data: { invoice: $scope.invoice } } ).success (response) ->
          $scope.invoice.errors = response.errors
          unless $scope.hasErrors()
            $window.location = response.index_url
          else
            return $scope.submitted = false
      $scope.submitted = true unless status == "draft"

    $scope.hasErrors = ->
      $scope.invoice.errors && Object.keys($scope.invoice.errors).length > 0

    $scope.invoiceTotal = ->
      total = $scope.subtotal() - $scope.discount()
      $scope.invoice.total = total
      total

    $scope.discount = ->
      discount = parseFloat($scope.invoice.discount_percent_as_billed)
      discount = 0 if isNaN(discount)
      amount = $scope.subtotal()
      answer = amount - (amount * ( 1 - (discount / 100) ))
      $scope.invoice.discount = answer
      answer

    $scope.subtotal = ->
      amount = 0
      return 0 unless $scope.invoice.runs && $scope.invoice.runs.length > 0

      mult = parseFloat( $scope.invoice.multiplier_as_billed )
      mult = 1 if isNaN(mult)

      for run in $scope.invoice.runs
        amount += run.damages_as_billed.subtotal

      amount

    $scope.destroy = ->
      $http( { method: "DELETE", url: $scope.invoice.destroy_url, data: { invoice: $scope.invoice } } ).success (response) ->
        $window.location = response.index_url
