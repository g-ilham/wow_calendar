window.Tasks =
  init: ->
    $('input.list-child').change ->
      if $(this).is(':checked')
        $(this).parents('li').addClass 'task-done'
      else
        $(this).parents('li').removeClass 'task-done'
      return
    return
