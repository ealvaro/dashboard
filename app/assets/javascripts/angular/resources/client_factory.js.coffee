Erdos.factory( 'Client', ['$resource', ($resource) ->
  $resource("/push/clients/:id", { id: "@id" }, {
    update: {method: "PUT"}
  })
])