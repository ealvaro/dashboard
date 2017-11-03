{a} = React.DOM

EmMenuItem = React.createClass
  propTypes:
    menuId: React.PropTypes.string
    onClick: React.PropTypes.func
  handleClick: (event) ->
    event.preventDefault()
    this.props.onClick this.props.menuId if this.props.onClick?
  render: ->
    a
      role: "menuitem"
      tabIndex: "-1"
      #key: this.props.menuId
      href: "#"
      onClick: this.handleClick
      this.props.children || "Untitled Entry"

exports = this
exports.EmMenuItem = EmMenuItem
