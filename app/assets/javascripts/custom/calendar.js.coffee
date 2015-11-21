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
        window.clicked_day_date = date
        window.current_all_day = false
        Calendar.show_new_or_edit_form('#new_event_form_modal',
                                        {}
                                      )

      eventClick: (event, jsEvent, view)->
        console.log ' '
        console.log 'eventClick'
        Calendar.set_global_current_event(event)
        Calendar.show_new_or_edit_form('#edit_event_form_modal',
                                        { 'title': event.title }
                                      )

      eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) ->
        console.log ' '
        console.log 'eventDrop'
        window.current_event_revert = revertFunc
        Calendar.set_global_current_event(event)
        CreateAndUpdateEvents.submit('drop_or_resize')

      eventResize: ( event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view ) ->
        console.log ' '
        console.log 'eventResize'
        window.current_event_revert = revertFunc
        Calendar.set_global_current_event(event)
        CreateAndUpdateEvents.submit('drop_or_resize')

  show_new_or_edit_form: (id, optional_hash)->
    template = Calendar.modal_template(id, optional_hash)
    $(id).empty()
    $(id).html(template)
    Calendar.activate_switch()
    FormDatetimepickers.new_init() if id == '#new_event_form_modal'
    FormDatetimepickers.edit_init() if id == '#edit_event_form_modal'
    $(id).modal('show')

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

  modal_template: (id, optional_hash)->
    if id == '#new_event_form_modal'
      window.new_event_template()
    else
      window.edit_event_template(optional_hash)

  set_global_current_event: (current_event)->
    window.current_event_start = current_event.start
    window.current_event_end = current_event.end
    window.current_event_id = current_event.id
    window.current_all_day = current_event.allDay
    window.current_event_title = current_event.title

  prepare_events_array: (events)->
    if events
      $.each events, (index, event_in_arr) ->
        if !event_in_arr['end']
          delete events[index]['end']
      events
    else
      events
