# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

loading = '<div class="container-fluid"><h1>Fetching results...</h1>
          <div class="progress">
            <div class="progress-bar progress-bar-info progress-bar-striped active" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
              <span class="sr-only">80% Complete (danger)</span>
            </div>
          </div></div>'

$(document).ready ->
  $('#global-search').submit (e) ->
    $('#main-content').html(loading)
