Erdos.filter 'showJob', () ->
  (receivers, showJobs, showClients, showRigs) ->
    result = []
    if( receivers )
      if showJobs.length == 0 && showClients.length == 0 && showRigs.length == 0
        return receivers
      else
        for receiver in receivers
          if (showJobs.length == 0 || showJobs.indexOf(receiver.job) > -1) &&
             (showClients.length == 0 || showClients.indexOf(receiver.client) > -1) &&
             (showRigs.length == 0 || showRigs.indexOf(receiver.rig) > -1)
            result.push receiver

    result
