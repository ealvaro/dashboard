Erdos.controller "InvoicesController", ($scope, $http, Client, Job) ->
  $scope.loading = true
  $scope.clients = Client.query({shallow: true})
  $scope.invoice = {}
  $scope.invoices = []
  $scope.submitted = false
  $scope.availableRuns = []

  $('.datetimepicker').datetimepicker()

  $http( { method: 'GET', url: '/push/invoices/new' } ).success( (response) ->
    $scope.invoice = response
  )

  $scope.jobSelected = ->
    $scope.invoice.job = Job.get($scope.invoice.job)
    $scope.invoice.job.$promise.then ->
      setAvailableRuns()
      $scope.invoice.runs = angular.copy($scope.availableRuns)
      $scope.availableRuns = []

  ## Initialization Methods
  $scope.indexInit = (json)->
    $scope.invoices = JSON.parse(json)
    $scope.index = true
    $scope.loading = false

  $scope.showInit = ->
    $scope.show = true

  $scope.editInit = (id) ->
    $scope.edit = true
    $http({method: 'GET', url:'/push/invoices/' + id.toString()}).success (response) ->
      $scope.invoice = response
      setAvailableRuns()

  ## Watches
  $scope.$watch( 'invoice', (invoice, oldInvoice) ->
    if oldInvoice.runs && oldInvoice.runs.length == 0 && invoice.runs.length > 0 && invoice.runs[0].multiplier
      $scope.invoice.multiplier_as_billed = invoice.runs[0].multiplier || 1.0 unless $scope.invoice.multiplier_as_billed
  , true )


  $scope.removeRun = (run) ->
    index = getIndex($scope.invoice.runs, run )
    $scope.invoice.runs.splice( index, 1 )

  $scope.addRun = (run) ->
    index = getIndex($scope.invoice.job.runs, run )
    $scope.invoice.runs.splice( index, 0, run )

  $scope.billable = (run) ->
    $scope.invoice && $scope.invoice.job && $scope.invoice.job.runs && getIndex($scope.invoice.job.runs, run ) >=0 && getIndex($scope.invoice.runs, run ) == -1

  ## helper methods
  setAvailableRuns = ->
    if $scope.invoice.job
      for run in $scope.invoice.job.runs
        $scope.availableRuns.push run if !run.invoice_id
    $scope.availableRuns

  getIndex = (collection, object) ->
    index = 0
    for item in collection
      if item.id == object.id
        return index
      index += 1
    return -1

  $scope.exportColumnKeys = [
    "client.name",
    "number",
    "job.name",
    "run_numbers",
    "updated_at",
    "status"
  ]

  $scope.headers = [
    {
      ordered: true,
      key: 'client.name',
      label: 'Client',
      url: 'client.show_url'
    },
    {
      ordered: true,
      key: 'number',
      label: 'Number',
      url: 'show_url'
    },
    {
      ordered: true,
      key: 'job.name',
      label: 'Job',
      url: 'job.show_url'
    },
    {
      ordered: false,
      key: 'run_numbers',
      label: 'Run Numbers'
    },
    {
      ordered: true,
      key: 'updated_at',
      label: 'Updated At'
    },
    {
      ordered: true,
      key: 'status',
      label: 'Status'
    }
  ]
