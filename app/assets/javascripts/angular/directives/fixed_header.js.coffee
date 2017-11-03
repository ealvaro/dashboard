Erdos.directive "fixedHeader", ($timeout) ->
  restrict: 'A'
  scope:
    scrollToBottom: '@'
  link: ($scope, $elem, $attrs, $ctrl) ->
    elem = $elem[0]

    tableDataLoaded = ->
      # first cell doesn't have a width until after table transformation
      firstCell = elem.querySelector('tbody tr:first-child td:first-child')
      firstCell and not firstCell.style.width

    $scope.$watch tableDataLoaded, (loaded) ->
      transformTable() if loaded

    transformTable = ->
      angular.element(elem.querySelectorAll('thead, tbody, tfoot'))
        .css('display', '').css('visibility', 'hidden')

      $timeout ->
        # set column widths
        angular.forEach elem.querySelectorAll('tr:first-child th'), (thElem, i) ->
          select = "tr:first-child td:nth-child(#{i + 1})"
          tdElems = elem.querySelector "tbody #{select}"
          tfElems = elem.querySelector "tfoot #{select}"

          colWidth = thElem.offsetWidth
          if tdElems? and tdElems.offsetWidth > colWidth
            colWidth = tdElems.offsetWidth

          tdElems?.style.width = colWidth + 'px'
          thElem?.style.width = colWidth + 'px'
          tfElems?.style.width = colWidth + 'px'

        # set css styles
        angular.element(elem.querySelectorAll('thead, tfoot')).css
          'display': 'block'
          'visibility': 'visible'
        angular.element(elem.querySelectorAll('tbody')).css
          'display': 'block'
          'visibility': 'visible'
          'height': $attrs.tableHeight or 'inherit'
          'overflow': 'scroll'

        # fix up for scrollbar
        tbody = elem.querySelector('tbody')
        scrollBarWidth = tbody.offsetWidth - tbody.clientWidth
        if scrollBarWidth > 0
          scrollBarWidth -= 2
          lastCol = elem.querySelector('tbody tr:first-child td:last-child')
          lastCol.style.width = (lastColumn.offsetWidth - scrollBarWidth) + 'px'

        tbody.scrollTop = ($scope.scrollToBottom? && tbody.scrollHeight) || 0
