window.BaseHandlebars =
  new_event: ->
    window.new_event_template = Handlebars.compile($('#new_event_template').html())
  edit_event: ->
    window.edit_event_template = Handlebars.compile($('#edit_event_template').html())
