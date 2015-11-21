window.CreateAndUpdateEvents =
  init: (create_event_path)->
    window.create_event_path = create_event_path

    $(document).on 'click', '.js-create-event-link', ->
      SubmitEventForm.submit('not_drop_or_resize', $(@))
      return false

    $(document).on 'click', '.js-update-event-link', ->
      SubmitEventForm.submit('not_drop_or_resize', $(@))
      return false
