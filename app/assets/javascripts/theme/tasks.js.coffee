window.Tasks =
  init: ->
    $('input.list-child').change ->
      if $(this).is(':checked')
        $(this).parents('li').addClass 'task-done'
      else
        $(this).parents('li').removeClass 'task-done'

    Tasks.sortable_init()

  sortable_init: ->
    $('#sortable').sortable()
    $('#sortable').disableSelection()
