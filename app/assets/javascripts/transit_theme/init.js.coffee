$ ->
  $window = $(window)
  $body = $('body')
  # Disable animations/transitions until the page has loaded.
  $body.addClass 'is-loading'
  $window.on 'load', ->
    $body.removeClass 'is-loading'
    return
  return
