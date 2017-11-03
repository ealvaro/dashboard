{a, ul, li} = React.DOM

EmPagination = React.createClass
  propTypes:
    totalItems: React.PropTypes.number.isRequired
    itemsPerPage: React.PropTypes.number.isRequired
    currentPage: React.PropTypes.number.isRequired
    onPageClick: React.PropTypes.func
  handleClick: (page, e) ->
    e.preventDefault()
    if this.props.onPageClick? && page > 0
      this.props.onPageClick page: page
  calculateTotalPages: ->
    totalPages = 1
    if this.props.itemsPerPage > 0
      totalPages = Math.ceil(this.props.totalItems / this.props.itemsPerPage)
    Math.max(totalPages || 0, 1)
  noPrev: -> this.props.currentPage == 1
  noNext: -> this.props.currentPage == this.calculateTotalPages()
  renderListItem: (text, page, isActive, isDisabled) ->
    page = -1 if isDisabled
    link = a href: "#", onClick: this.handleClick.bind(this, page), text
    activeClass = if isActive then "active" else ""
    disabledClass = if isDisabled then "disabled" else ""
    li key: text, className: "#{activeClass} #{disabledClass}", link
  renderListItems: ->
    items = [this.renderListItem "First", 1, false, this.noPrev()]
    items.push this.renderListItem "«", this.props.currentPage - 1, false, this.noPrev()

    totalPages = this.calculateTotalPages()
    for page in [1..totalPages]
      isActive = page == this.props.currentPage
      items.push this.renderListItem page, page, isActive, false

    items.push this.renderListItem "»", this.props.currentPage + 1, false, this.noNext()
    items.push this.renderListItem "Last", totalPages, false, this.noNext()
    items
  render: ->
    ul className: "pagination margin-none", this.renderListItems()

exports = this
exports.EmPagination = EmPagination
