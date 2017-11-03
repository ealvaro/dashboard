{a, i, th} = React.DOM

EmTableHeaderCell = React.createClass
  propTypes:
    isActive: React.PropTypes.bool  # only valid if isOrdered
    isOrdered: React.PropTypes.bool
    sortKey: React.PropTypes.string
    sortDir: React.PropTypes.string
    onHeaderClick: React.PropTypes.func
  handleClick: (e) ->
    e.preventDefault()
    if this.props.onHeaderClick?
      this.props.onHeaderClick sortKey: this.props.sortKey
  render: ->
    children = this.props.children
    if this.props.isOrdered and this.props.isActive
      dir = (this.props.sortDir == "asc" && "up") || "down"
      children = [
        this.props.children,
        i key: "i", className: "zmdi zmdi-triangle-#{dir}"]
    th className: "header.css_class",
      if this.props.isOrdered
        a
          href: '#'
          onClick: this.handleClick,
          children
      else
        children

exports = this
exports.EmTableHeaderCell = EmTableHeaderCell
