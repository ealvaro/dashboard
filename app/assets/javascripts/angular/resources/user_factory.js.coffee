Erdos.factory( 'User', ['$resource', ($resource) ->
  $resource("/push/users/:id", { id: "@id" }, {
    update: {method: "PUT"}
    currentUser: {method: 'GET', url: '/push/current_user'}
  })
])
