window.FormDatetimepickers =
  new_init: ->
    self = FormDatetimepickers
    self.disable_datetimepickers('#starts_at_date', '#ends_at_date')

    $('#starts_at_date').datetimepicker(
      $.extend({}, self.base_confs(), defaultDate: window.clicked_day_date)
    )

    $('#ends_at_date').datetimepicker(
      self.base_confs()
    )

  edit_init: ->
    self = FormDatetimepickers
    self.disable_datetimepickers('#starts_at_date_on_edit', '#ends_at_date_on_edit')

    $('#starts_at_date_on_edit').datetimepicker(
      $.extend({}, self.base_confs(), defaultDate: window.current_event_start)
    )

    $('#ends_at_date_on_edit').datetimepicker(
      $.extend({}, self.base_confs(), defaultDate: window.current_event_end)
    )

  disable_datetimepickers: (start_id, end_id)->
    if $(start_id).data("DateTimePicker")
      $(start_id).data("DateTimePicker").destroy()
    if $(end_id).data("DateTimePicker")
      $(end_id).data("DateTimePicker").destroy()

  base_confs: ->
    {
      useCurrent: false,
      locale: 'ru'
    }
