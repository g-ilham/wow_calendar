window.Calendar =
  init: (events)->
    window.calendar_events = JsonParser.run(events)
    window.calendar_events = Calendar.prepare_events_array(window.calendar_events)
    Calendar.calendar_init()

  calendar_init: ->
    window.my_full_calendar = $('#calendar').fullCalendar
      header:
        left: 'prev, next, today',
        center: 'title',
        right: 'month, agendaWeek, agendaDay'
      defaultView: 'month',
      slotMinutes: 15,
      lang: 'ru',
      monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
      monthNamesShort: ['Янв.','Фев.','Март.','Апр.','Май.','Июнь.','Июль.','Авг.','Сент.','Окт.','Ноя.','Дек.'],
      dayNames: ["Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"],
      dayNamesShort: ["ВС","ПН","ВТ","СР","ЧТ","ПТ","СБ"],
      buttonText: {
          prev: "&nbsp;&#9668;&nbsp;",
          next: "&nbsp;&#9658;&nbsp;",
          prevYear: "&nbsp;&lt;&lt;&nbsp;",
          nextYear: "&nbsp;&gt;&gt;&nbsp;",
          today: "Сегодня",
          month: "Месяц",
          week: "Неделя",
          day: "День"
      },
      allDayText: 'Весь день',
      timeFormat: {
                    agenda: 'H:mm { - H:mm } ',
                  },
      editable: true,
      events: window.calendar_events,
      dayClick: (date, allDay, jsEvent, view)->
        console.log ' '
        console.log 'dayClick'
        console.log allDay
        window.current_event_start = date
        window.current_all_day = allDay
        Calendar.show_new_or_edit_form('new',
                                        {}
                                      )

      eventClick: (event, jsEvent, view)->
        console.log ' '
        console.log 'eventClick'
        console.log event
        console.log jsEvent
        console.log view
        Calendar.set_global_current_event(event)
        Calendar.show_new_or_edit_form('edit',
                                        { 'title': event.title }
                                      )
        if window.current_event_repeat_type
          $('#event_repeat').val(window.current_event_repeat_type)

      eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) ->
        console.log ' '
        console.log 'eventDrop'
        Calendar.drop_or_resize(event, revertFunc)

      eventResize: ( event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view ) ->
        console.log ' '
        console.log 'eventResize'
        Calendar.drop_or_resize(event, revertFunc)

  drop_or_resize: (event, revertFunc)->
    window.current_event_revert = revertFunc
    Calendar.set_global_current_event(event)
    SubmitEventForm.submit('drop_or_resize')

  show_new_or_edit_form: (form_type, optional_hash)->
    template = Calendar.modal_template(form_type, optional_hash)
    $('#event_form_modal').empty()
    $('#event_form_modal').html(template)
    BootstrapSwitch.activate_switch()
    FormDatetimepickers.init(form_type)
    $('#event_form_modal').modal('show')

  modal_template: (form_type, optional_hash)->
    if form_type == 'new'
      window.new_event_template()
    else
      window.edit_event_template(optional_hash)

  set_global_current_event: (current_event)->
    window.current_event_start = current_event.start
    window.current_event_end = current_event.end
    window.current_event_id = current_event.id
    window.current_all_day = current_event.allDay
    window.current_event_title = current_event.title
    window.current_event_repeat_type = current_event.repeat_type

  prepare_events_array: (events)->
    if events
      $.each events, (index, event_in_arr) ->
        if event_in_arr && !event_in_arr['end']
          delete events[index]['end']

    events
