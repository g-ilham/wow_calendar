window.CreateAndUpdateEvents =
  init: (create_path)->
    window.create_path = create_path
    $(document).on 'click', '.js-create-event-link', ->
      $(@).addClass 'disabled'
      CreateAndUpdateEvents.submit('not_drop_or_resize', $(@))
      return false

    $(document).on 'click', '.js-update-event-link', ->
      $(@).addClass 'disabled'
      CreateAndUpdateEvents.submit('not_drop_or_resize', $(@))
      return false

  submit: (event_type, button)->
    self = CreateAndUpdateEvents
    path_and_request_type = self.path_and_request_type(button, event_type)

    $.ajax
      url: path_and_request_type['path']
      type: path_and_request_type['type']
      dataType: 'json'
      data: { event: self.get_form_params(event_type) }
      success: (response) =>
        if event_type != 'drop_or_resize'
          self.success_handle(button, response)

        window.current_event_revert = undefined
        return false

      error: (response) ->
        if event_type != 'drop_or_resize'
          self.errors_handle(response.responseJSON)
          button.removeClass 'disabled'
        else
          window.current_event_revert()

        window.current_event_revert = undefined
        return false

      statusCode: 500: ->
        if event_type != 'drop_or_resize'
          button.removeClass 'disabled'
        else
          window.current_event_revert()

        window.current_event_revert = undefined
        return false

  path_and_request_type: (button, event_type)->
    switch event_type
      when 'not_drop_or_resize'
        if button.hasClass 'js-create-event-link'
          {
            path: window.create_path,
            type: 'post'
          }
        else
          CreateAndUpdateEvents.update_path_and_request_type()

      when 'drop_or_resize'
        CreateAndUpdateEvents.update_path_and_request_type()

  update_path_and_request_type: ->
    {
      path: '/events/' + window.current_event_id,
      type: 'put'
    }

  get_form_params: (event_type)->
    if event_type != 'drop_or_resize'
      {
        title: $("#event_title").val(),
        starts_at: $("#event_starts_at").val(),
        ends_at: $("#event_ends_at").val(),
        all_day: $('.switch').bootstrapSwitch('status')
      }
    else
      {
        title: window.current_event_title,
        starts_at: window.current_event_start,
        ends_at: window.current_event_end,
        all_day: window.current_all_day
      }

  success_handle: (button, response)->
    window.current_event = Calendar.prepare_events_array(response.event)

    modal = if button.hasClass 'js-create-event-link'
      $('#new_event_form_modal')
    else
      window.my_full_calendar.fullCalendar( 'removeEvents',
                                            window.current_event[0].id )
      $('#edit_event_form_modal')

    window.my_full_calendar.fullCalendar( 'renderEvent',
                                            window.current_event[0], true )

    modal.modal('hide')

  errors_handle: (response)->
    errors_block = $('.event_errors')

    if response.errors
      errors_block.removeClass 'hidden'
      CreateAndUpdateEvents.show_errors(response.errors, errors_block)
    else
      errors_block.addClass 'hidden'

  show_errors: (errors, errors_block)->
    errors_list = errors_block.find('ol').empty()

    $.each errors, (index, error) ->
      error = "<li class='event-error'>" + error + "</li>"
      errors_list.append(error)
