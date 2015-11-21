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

    $('#event_all_day').on 'change', () ->
      value = $('#event_form_modal').find(":checked").val()
      console.log value

      value = if value == 'on'
        true
      else if value == 'off'
        false
      else
        false

      window.current_all_day = value
      return
