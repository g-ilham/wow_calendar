window.FormDatetimepickers =
  init: (form_type)->
    self = FormDatetimepickers
    self.disable_datetimepickers()

    $('#starts_at_date').datetimepicker(
      $.extend({}, self.base_confs(), defaultDate: window.current_event_start)
    )

    $('#ends_at_date').datetimepicker(
      self.get_ends_at_options(form_type)
    )

  get_ends_at_options: (form_type)->
    self = FormDatetimepickers
    if form_type == 'new'
      self.base_confs()
    else
      $.extend({}, self.base_confs(), defaultDate: window.current_event_end)

  disable_datetimepickers: ->
    if $('#starts_at_date').data("DateTimePicker")
      $('#starts_at_date').data("DateTimePicker").destroy()
    if $('#ends_at_date').data("DateTimePicker")
      $('#ends_at_date').data("DateTimePicker").destroy()

  base_confs: ->
    {
      useCurrent: false,
      locale: 'ru'
    }
