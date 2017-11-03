Erdos.factory( 'Invoice', ['$resource', ($resource) ->
  $resource("/push/invoices/:id", { id: "@id" }, {
    update: {method: "PUT"},
    job_query: {method: "GET", url: '/push/jobs/:job_id/invoices', isArray: true }
  })
])
