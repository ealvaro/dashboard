{thead, tr, th} = React.DOM

EmTableHeader = React.createClass
  propTypes:
    columns: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    onHeaderClick: React.PropTypes.func
    sortKey: React.PropTypes.string
    sortDir: React.PropTypes.string
    displayActions: React.PropTypes.bool
  handleHeaderClick: (data) ->
    this.props.onHeaderClick(data) if this.props.onHeaderClick?
  renderColumns: ->
    this.props.columns.map ((column) ->
      React.createElement EmTableHeaderCell,
        isActive: this.props.sortKey == column.key
        isOrdered: column.ordered
        sortKey: column.key
        sortDir: this.props.sortDir
        onHeaderClick: this.handleHeaderClick,
        key: column.label
        column.label
      ).bind this
  render: ->
    columns = this.renderColumns()
    if this.props.displayActions
      columns.push React.createElement EmTableHeaderCell, key: "Actions", "Actions"
    thead null,
      tr null, columns

exports = this
exports.EmTableHeader = EmTableHeader
