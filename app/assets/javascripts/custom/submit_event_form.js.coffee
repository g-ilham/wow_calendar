window.SubmitEventForm =
  submit: (event_type, button)->
    self = SubmitEventForm
    path_and_request_type = self.path_and_request_type(button, event_type)
    btn_classes = BaseScripts.event_form_btn_classes()
    BaseScripts.toogle_class_for_elements(btn_classes, 'add')

    console.log ' '
    console.log 'submit data'

    $.ajax
      url: path_and_request_type['path']
      type: path_and_request_type['type']
      dataType: 'json'
      data: { event: self.get_form_params(event_type) }
      success: (response) =>
        self.success_handle(button, response, event_type)
        window.current_event_revert = undefined
        return false

      error: (response) ->
        if event_type != 'drop_or_resize'
          self.errors_handle(response)
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
        else
          window.current_event_revert()

        window.current_event_revert = undefined
        return false

      statusCode: 500: ->
        if event_type != 'drop_or_resize'
          BaseScripts.toogle_class_for_elements(btn_classes, 'remove')
        else
          window.current_event_revert()

        window.current_event_revert = undefined
        return false

  path_and_request_type: (button, event_type)->
    switch event_type
      when 'not_drop_or_resize'
        if button.hasClass 'js-create-event-link'
          {
            path: window.create_event_path,
            type: 'post'
          }
        else
          SubmitEventForm.update_path_and_request_type()

      when 'drop_or_resize'
        SubmitEventForm.update_path_and_request_type()

  update_path_and_request_type: ->
    {
      path: '/events/' + window.current_event_id,
      type: 'put'
    }

  get_form_params: (event_type)->
    console.log 'get_form_params'
    console.log 'event_type: ' + event_type

    if event_type == 'not_drop_or_resize'
      {
        title: $("#event_title").val(),
        starts_at: $("#event_starts_at").val(),
        ends_at: $("#event_ends_at").val(),
        all_day: $('.switch').bootstrapSwitch('status'),
        repeat_type: $('#event_repeat').val()
      }
    else
      {
        title: window.current_event_title,
        starts_at: window.current_event_start,
        ends_at: window.current_event_end,
        all_day: window.current_all_day,
        repeat_type: window.current_event_repeat_type
      }

  success_handle: (button, response, event_type)->
    self = SubmitEventForm
    if response && response.event
      window.current_event = Calendar.prepare_events_array(response.event)
      window.repeated_event = Calendar.prepare_events_array(response.repeated_event)

      if event_type != 'drop_or_resize'
        if !button.hasClass 'js-create-event-link'
          window.my_full_calendar.fullCalendar( 'removeEvents',
                                                window.current_event[0].id )


          window.my_full_calendar.fullCalendar( 'renderEvent',
                                                window.current_event[0], true )

      RemoveEvent.render_new_repeated_event()

      $('#event_form_modal').modal('hide')

  errors_handle: (response)->
    errors_block = $('.event_errors')

    if response && response.responseJSON.errors
      errors_block.removeClass 'hidden'
      SubmitEventForm.show_errors(response.responseJSON.errors, errors_block)
    else
      errors_block.addClass 'hidden'

  show_errors: (errors, errors_block)->
    errors_list = errors_block.find('ol').empty()

    $.each errors, (index, error) ->
      error = "<li class='event-error'>" + error + "</li>"
      errors_list.append(error)
