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

    self.update_ends_date_after_change_start_date()

  update_ends_date_after_change_start_date: ->
    self = FormDatetimepickers
    $('#starts_at_date').on 'dp.hide', (e) ->
      update_start_date = e.date.toDate()
      ends_date_params = $('#ends_at_date').data("DateTimePicker").date()

      ends_date = if ends_date_params
        ends_date_params.toDate()
      else
        undefined

      if (!ends_date || update_start_date > ends_date) && !window.current_all_day
        $('#ends_at_date').data("DateTimePicker").date(self.increase_date(update_start_date))
      return

  get_ends_at_options: (form_type)->
    self = FormDatetimepickers
    if form_type == 'new'
      if window.current_all_day
        self.base_confs()
      else
        $.extend({}, self.base_confs(), defaultDate: self.increase_date(window.current_event_start))
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

  increase_date: (current_date)->
    moment(current_date).add(10, 'm').toDate()
