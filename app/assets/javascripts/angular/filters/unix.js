Erdos.filter('momentUnix', function() {
  return function(timestamp, format) {
    if (timestamp === null) {
      return ""
    }
    return moment.unix(timestamp);
  };
});
