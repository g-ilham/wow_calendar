window.EmptyClick =
  init: ->
    $(document).on 'click', '.js-empty-click', ->
      return false
