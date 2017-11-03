Erdos.factory( 'Job', ['$resource', ($resource) ->
  $resource("/push/jobs/:id", { id: "@id" }, {
    update: {method: "PUT"}
  })
])
