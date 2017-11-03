{span, div, li, ul, table, tbody, tr, td} = React.DOM

itemHeight = 37

EmGammaTable = React.createClass
  propTypes:
    gammas: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    height: React.PropTypes.number.isRequired
  getInitialState: ->
    scrollTop: 0
    needsScrollToBottom: false
  componentDidMount: ->
    this.outer().addEventListener 'scroll', this.handleScroll
  componentWillUnmount: ->
    this.outer().removeEventListener 'scroll', this.handleScroll
  componentWillReceiveProps: (props) ->
    this.setState needsScrollToBottom: true
  componentDidUpdate: ->
    height = (this.props.gammas.length - 1) * itemHeight
    inner = document.querySelector('.inner')
    inner.style.height = "#{height - parseInt(inner.style.top)}px"

    if this.state.needsScrollToBottom
      scrollTop = this.props.gammas.length * itemHeight - this.props.height
      this.outer().scrollTop = scrollTop
      this.setState
        scrollTop: scrollTop
        needsScrollToBottom: false
  outer: -> document.querySelector('.outer')
  handleScroll: (e) ->
    this.setState
      scrollTop: Math.max e.target?.scrollTop, 0
  render: ->
    begin = this.state.scrollTop / itemHeight | 0
    # Add 2 so that the top and bottom of the page are filled with
    # next/prev item, not just whitespace if item not in full view
    end = begin + (this.props.height / itemHeight | 0) + 2
    offset = begin * itemHeight

    liStyleHead =
      height: 40
      backgroundColor: "#fff"
      listStyle: "none"
      width: "100%"
      fontSize: 16
      fontWeight: "bold"
      color: "#666"
      whiteSpace: "nowrap"

    liStyle = (even) ->
      height: "#{itemHeight}px"
      backgroundColor: if even then "#fff" else "#f6f6f6"
      listStyle: "none"
      width: "100%"

    style =
      float: 'left'
      width: "50%"
      padding: 8

    even = begin % 2 == 0
    div null,
      ul style: marginBottom: 1, paddingLeft: 0,
        li style: liStyleHead,
          span style: style, "Measured Depth"
          span style: style, "Counts"
      div className: "outer", style: height: this.props.height, overflowY: "scroll",
        ul className: "inner", style: position: "relative", top: offset, paddingLeft: 0,
          this.props.gammas.slice(begin, end).map (item) ->
            even = not even
            li key: item.measured_depth, style: liStyle(even),
              span style: style, emFormatNumber item.measured_depth
              span style: style, emFormatNumber item.count

Erdos.directive 'emGammaTable', (reactDirective) ->
  reactDirective EmGammaTable

exports = this
exports.EmGammaTable = EmGammaTable
