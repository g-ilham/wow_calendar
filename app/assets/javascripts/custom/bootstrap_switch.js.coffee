window.BootstrapSwitch =
  activate_switch: ->
    $('.switch').bootstrapSwitch('destroy')
    $('#event_all_day').off('change')

    element = if $('.switch').length
      $('.switch')
    else
      $('[data-toggle=\'switch\']').
                                    wrap('<div class="switch" />').
                                    parent()

    element.bootstrapSwitch()
    element.bootstrapSwitch('setState', window.current_all_day)
    BootstrapSwitch.add_switch_handler()

  add_switch_handler: ->
    $('#event_all_day').on 'change', () ->
      value = $('#event_form_modal .all_day').find(":checked").val()
      console.log value

      value = BootstrapSwitch.parse_switch_value(value)
      window.current_all_day = value

      if !value
        starts_date = $('#starts_at_date').data("DateTimePicker").date()
        FormDatetimepickers.set_ends_at_column_to_starts_at(starts_date)
      return

  parse_switch_value: (value)->
    if value == 'on'
      true
    else if value == 'off'
      false
    else
      false
