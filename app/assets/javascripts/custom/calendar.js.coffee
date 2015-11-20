window.Calendar =
  init: (events)->
    window.calendar_events = JsonParser.run(events)
    CommonScripts.accordion()
    CommonScripts.sidebartoogle()
    CommonScripts.sidebarScrollMask()
    CommonScripts.customScrollbar()
    $('fa.tooltips').tooltip()
    Calendar.calendar_init()

  calendar_init: ->
    $('#calendar').fullCalendar
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
        console.log jsEvent
        console.log view
        window.clicked_day_date = date
        $('#new_event_form_modal').empty()
        $('#new_event_form_modal').html(window.new_event_template)
        $('.switch').bootstrapSwitch(
          state: false
        )
        FormDatetimepickers.new_init()
        $('#new_event_form_modal').modal('show')

      eventClick: (event, jsEvent, view)->
        console.log ' '
        console.log 'eventClick'
        console.log event
        console.log jsEvent
        console.log view
        window.current_event_start = event.start
        window.current_event_end = event.end
        $('#edit_event_form_modal').empty()
        $('#edit_event_form_modal').html(window.edit_event_template({'title': event.title}))
        $('.switch').bootstrapSwitch(
          state: event.allDay
        )
        FormDatetimepickers.edit_init()
        $('#edit_event_form_modal').modal('show')
