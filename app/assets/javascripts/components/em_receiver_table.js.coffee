{div, table} = React.DOM

# Use factory to leverage angular DI
Erdos.factory 'EmReceiverTable', ($filter) ->
  React.createClass
    propTypes:
      headers: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
      objects: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
      loading: React.PropTypes.bool
    getInitialState: ->
      sortDir: 'asc'
      currentPage: 1
      detailsJobs: []
      itemsPerPage: 25
    componentWillReceiveProps: (props) ->
      if not this.state.sortKey && props.headers.length > 0
        sortKey = _.findWhere(props.headers, key: 'job')?.key
        sortKey = sortKey || _.findWhere(props.headers, ordered: true)?.key
        this.setState sortKey: sortKey
    handleHeaderClick: (data) ->
      if data.sortKey == this.state.sortKey
        sortDir = if this.state.sortDir == 'asc' then 'desc' else 'asc'
        this.setState sortDir: sortDir
      else
        this.setState
          sortDir: 'asc'
          sortKey: data.sortKey
    handlePageClick: (data) ->
      this.setState currentPage: data.page if data.page > 0
    copyToClipboard: (text) ->
      window.prompt("Copy to clipboard: Ctrl+C, Enter", text);
    handleMenuSelection: (object, menuId) ->
      switch menuId
        when "details"
          this.state.detailsJobs.push object.job.toLowerCase()
          this.setState detailsJobs: this.state.detailsJobs
        else
          this.copyToClipboard object.last_updates[menuId].team_viewer_id
    handleHideDetails: (object) ->
      jobs = this.state.detailsJobs
      jobs.splice jobs.indexOf(object.job.toLowerCase()), 1
      this.setState detailsJobs: jobs
    renderHeader: ->
      React.createElement EmTableHeader,
        columns: this.props.headers
        onHeaderClick: this.handleHeaderClick
        sortKey: this.state.sortKey
        sortDir: this.state.sortDir
        displayActions: true
    renderBody: (objects) ->
      React.createElement EmReceiverTableBody,
        headers: this.props.headers
        objects: objects
        displayActions: true
        detailsJobs: this.state.detailsJobs
        onMenuSelection: this.handleMenuSelection
        onHideDetails: this.handleHideDetails
    renderPagination: (totalItems) ->
      React.createElement EmPagination,
        totalItems: totalItems
        itemsPerPage: this.state.itemsPerPage
        currentPage: this.state.currentPage
        onPageClick: this.handlePageClick
    render: ->
      if this.props.loading
        React.createElement EmLoadingIndicator
      else
        objects = $filter('orderBy') this.props.objects, this.state.sortKey, this.state.sortDir == 'desc'
        objectCount = objects.length
        objects = $filter('paginate') objects, this.state.currentPage, this.state.itemsPerPage
        div null,
          table
            key: 'Receiver'
            className:'table grey-white',
            this.renderHeader(),
            this.renderBody(objects)
          this.renderPagination objectCount
