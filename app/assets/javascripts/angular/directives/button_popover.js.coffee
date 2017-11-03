Erdos.directive "buttonPopover", ($compile) ->
  restrict: 'E'
  replace: true
  scope:
    title: '@'
    content: '@'
  templateUrl: "button_popover.html"
  link: (scope, elem, attrs) ->
    elem.popover(
      trigger: 'click',
      html: true,
      title: scope.title,
      content: scope.content,
      placement: 'left')
      .click ->
        opened = /has-open-popover/.test elem.attr("class")
        if opened
          elem.removeClass('has-open-popover')
        else
          $compile(angular.element('.popover.in').contents())(scope)

        # close the other popovers (only want one open at a time)
        angular.element('.has-open-popover').click()

        if not opened
          elem.addClass('has-open-popover')

    scope.dismiss = ->
      elem[0].click()
