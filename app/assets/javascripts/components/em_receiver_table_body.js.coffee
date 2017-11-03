{tbody, tr, td} = React.DOM

EmReceiverTableBody = React.createClass
  propTypes:
    headers: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    objects: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    displayActions: React.PropTypes.bool
    detailsJobs: React.PropTypes.arrayOf(React.PropTypes.string)
    onMenuSelection: React.PropTypes.func
    onHideDetails: React.PropTypes.func
  handleMenuSelection: (object, menuId) ->
    this.props.onMenuSelection object, menuId
  handleHide: (object) ->
    this.props.onHideDetails object
  renderDataCells: (object) ->
    this.props.headers.map ((header) ->
      td key: "td-#{header.key}", React.createElement EmTableData,
        object: object
        okey: header.key
        url: header.url
        klass: 'Receiver'
    ).bind this
  renderActionCell: (object) ->
    td key: "td-#{object.job}",
      React.createElement EmReceiverCog,
        object: object
        onMenuSelection: this.handleMenuSelection.bind this, object
  render: ->
    objectClass = (object) ->
      classes = []
      classes.push 'alerting-job' if object.has_active_alert
      classes.push 'pumps-off' if object.pumps_off
      classes.join " "
    colspan = this.props.headers.length + (this.props.displayActions || 0)
    tbody null, this.props.objects.map ((object) ->
      unless object.inactive
        dataCells = this.renderDataCells object
        dataCells.push this.renderActionCell(object) if this.props.displayActions
        if object.job.toLowerCase() in this.props.detailsJobs
          dataCells = td colSpan: "#{colspan}",
            React.createElement EmReceiverDetails,
              receiver: object
              onHide: this.handleHide.bind this, object
        tr
          className: objectClass object
          key: "tr-#{object.job.toLowerCase()}",
          dataCells
    ).bind this

exports = this
exports.EmReceiverTableBody = EmReceiverTableBody
