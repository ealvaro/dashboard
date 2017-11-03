$ ->
  $("select#selectit").on('change', (e) ->
    $(e.target).parent('form').append($("<i class='fa fa-cog fa-spin'></i>"))
    setTimeout(->
      $(e.target).parent('form').submit()
    , 5)
  )
  $('.dropdown-menu input, .dropdown-menu label').on('click', (e) ->
    e.stopPropagation()
  )
  $('.summary').popover( trigger: 'hover' )

  $("table.sorted").tablesorter( headerTemplate : '{content}{icon}', cssIcon: 'fa fa-sort pull-right')
