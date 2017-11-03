Erdos.service 'Notifier', ($http) ->
  createGlobal: (notifier) ->
    $http(
      method: "POST"
      url: '/global_notifiers'
      data:
        notifier: notifier
      )

  createGroup: (notifier) ->
    $http(
      method: "POST"
      url: '/group_notifiers'
      data:
        notifier: notifier
      )

  createRig: (notifier) ->
    $http(
      method: "POST"
      url: '/rig_notifiers'
      data:
        notifier: notifier
      )

  createTemplate: (notifier) ->
    $http(
      method: "POST"
      url: '/template_notifiers'
      data:
        notifier: notifier
      )

  save: (notifier) ->
    $http(
      method: "PUT"
      url: '/notifiers/' + notifier.id
      data:
        notifier: notifier
      )

  updates_fields: (callback) ->
    $http(
      method: "GET"
      url: "/notifiers/updates_fields"
    ).success (response) ->
      callback(response)
