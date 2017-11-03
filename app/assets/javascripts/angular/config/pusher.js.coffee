Erdos.config (PusherServiceProvider) ->
  key = $("body").attr("data-pusher-key")
  PusherServiceProvider
    .setToken(key)
    .setOptions({})
