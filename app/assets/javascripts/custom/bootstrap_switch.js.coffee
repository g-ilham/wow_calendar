window.BootstrapSwitch =
  activate_switch: ->
    $('.switch').bootstrapSwitch('destroy')
    element = if $('.switch').length
      $('.switch')
    else
      $('[data-toggle=\'switch\']').
                                    wrap('<div class="switch" />').
                                    parent()

    element.bootstrapSwitch()
    element.bootstrapSwitch('setState', window.current_all_day)
