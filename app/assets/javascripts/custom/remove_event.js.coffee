window.RemoveEvent =
  init: ->
    self = RemoveEvent
    $(document).on 'click', '.js-event-remove', ->
      self.submit($('.js-event-remove'), $('.js-update-event-link'))
      return false

  submit: (remove_button)->
    if window.current_event_id
      btn_classes = BaseScripts.event_form_btn_classes()
      BaseScripts.toogle_class_for_elements(btn_classes, 'add')

      $.ajax
        url: '/events/' + window.current_event_id
        type: 'delete'
        dataType: 'json'
        data: {}
        success: (response) =>
          window.my_full_calendar.fullCalendar('removeEvents', window.current_event_id)
          $('#event_form_modal').modal('hide')
          return false

        error: (response) ->
          SubmitEventForm.errors_handle(response)
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
          return false

        statusCode: 500: ->
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
          return false
