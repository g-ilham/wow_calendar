window.BaseScripts =
  init: ->
    CommonScripts.accordion()
    CommonScripts.sidebartoogle()
    CommonScripts.sidebarScrollMask()
    CommonScripts.customScrollbar()
    $('.tooltips').tooltip()

  event_form_btn_classes: ->
    [ '.js-event-remove', '.js-update-event-link', '.js-create-event-link']

  toogle_class_for_elements: (el_classes, type, desiredClass)->
    $.each el_classes, (index, el_class) ->
      if type == 'add'
        $(el_class).addClass(desiredClass || 'disabled')
      else
        $(el_class).removeClass(desiredClass || 'disabled')
