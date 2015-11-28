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
          if response && response.repeated_event
            window.repeated_event = response.repeated_event

            if window.repeated_event[0]
              events = window.my_full_calendar.fullCalendar( 'clientEvents' )
              if events
                accept_to_render = true

                $.each events, (index, event) ->
                  if event.id == window.repeated_event[0].id
                    accept_to_render = false

                if accept_to_render
                  window.my_full_calendar.fullCalendar( 'renderEvent',
                                                        window.repeated_event[0], true )
          $('#event_form_modal').modal('hide')
          return false

        error: (response) ->
          SubmitEventForm.errors_handle(response)
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
          return false

        statusCode: 500: ->
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
          return false
