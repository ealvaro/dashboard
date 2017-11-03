{div, small} = React.DOM

EmLoadingIndicator = React.createClass
  render: ->
    div null,
      div className: "progress progress-striped active",
        div className:"progress-bar", style: width: "100%"
      small null, "loading..."

exports = this
exports.EmLoadingIndicator = EmLoadingIndicator
