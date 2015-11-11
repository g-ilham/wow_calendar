window.FormComponent =
  init: ->
    #checkbox and radio btn
    d = document
    safari = if navigator.userAgent.toLowerCase().indexOf('safari') != -1 then true else false

    gebtn = (parEl, child) ->
      parEl.getElementsByTagName child

    onload = ->
      body = gebtn(d, 'body')[0]
      body.className = if body.className and body.className != '' then body.className + ' has-js' else 'has-js'
      if !d.getElementById or !d.createTextNode
        return
      ls = gebtn(d, 'label')
      i = 0
      while i < ls.length
        l = ls[i]
        if l.className.indexOf('label_') == -1
          i++
          continue
        inp = gebtn(l, 'input')[0]
        if l.className == 'label_check'
          l.className = if safari and inp.checked == true or inp.checked then 'label_check c_on' else 'label_check c_off'
          l.onclick = check_it
        if l.className == 'label_radio'
          l.className = if safari and inp.checked == true or inp.checked then 'label_radio r_on' else 'label_radio r_off'
          l.onclick = turn_radio
        i++
      return

    check_it = ->
      inp = gebtn(this, 'input')[0]
      if @className == 'label_check c_off' or !safari and inp.checked
        @className = 'label_check c_on'
        if safari
          inp.click()
      else
        @className = 'label_check c_off'
        if safari
          inp.click()
      return

    turn_radio = ->
      inp = gebtn(this, 'input')[0]
      if @className == 'label_radio r_off' or inp.checked
        ls = gebtn(@parentNode, 'label')
        i = 0
        while i < ls.length
          l = ls[i]
          if l.className.indexOf('label_radio') == -1
            i++
            continue
          l.className = 'label_radio r_off'
          i++
        @className = 'label_radio r_on'
        if safari
          inp.click()
      else
        @className = 'label_radio r_off'
        if safari
          inp.click()
      return

    $ ->
      # Tags Input
      $('.tagsinput').tagsInput()
      # Switch
      $('[data-toggle=\'switch\']').wrap('<div class="switch" />').parent().bootstrapSwitch()
      return
    #color picker
    $('.cp1').colorpicker format: 'hex'
    $('.cp2').colorpicker()
    #date picker
    if top.location != location
      top.location.href = document.location.href
    $ ->
      window.prettyPrint and prettyPrint()
      $('#dp1').datepicker format: 'mm-dd-yyyy'
      $('#dp2').datepicker()
      $('#dp3').datepicker()
      $('#dp3').datepicker()
      $('#dpYears').datepicker()
      $('#dpMonths').datepicker()
      startDate = new Date(2012, 1, 20)
      endDate = new Date(2012, 1, 25)
      $('#dp4').datepicker().on 'changeDate', (ev) ->
        if ev.date.valueOf() > endDate.valueOf()
          $('#alert').show().find('strong').text 'The start date can not be greater then the end date'
        else
          $('#alert').hide()
          startDate = new Date(ev.date)
          $('#startDate').text $('#dp4').data('date')
        $('#dp4').datepicker 'hide'
        return
      $('#dp5').datepicker().on 'changeDate', (ev) ->
        if ev.date.valueOf() < startDate.valueOf()
          $('#alert').show().find('strong').text 'The end date can not be less then the start date'
        else
          $('#alert').hide()
          endDate = new Date(ev.date)
          $('#endDate').text $('#dp5').data('date')
        $('#dp5').datepicker 'hide'
        return
      # disabling dates
      nowTemp = new Date
      now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
      checkin = $('#dpd1').datepicker(onRender: (date) ->
        if date.valueOf() < now.valueOf() then 'disabled' else ''
      ).on('changeDate', (ev) ->
        if ev.date.valueOf() > checkout.date.valueOf()
          newDate = new Date(ev.date)
          newDate.setDate newDate.getDate() + 1
          checkout.setValue newDate
        checkin.hide()
        $('#dpd2')[0].focus()
        return
      ).data('datepicker')
      checkout = $('#dpd2').datepicker(onRender: (date) ->
        if date.valueOf() <= checkin.date.valueOf() then 'disabled' else ''
      ).on('changeDate', (ev) ->
        checkout.hide()
        return
      ).data('datepicker')
      return
    #daterange picker
    $('#reservation').daterangepicker()
    $('#reportrange').daterangepicker {
      ranges:
        'Today': [
          'today'
          'today'
        ]
        'Yesterday': [
          'yesterday'
          'yesterday'
        ]
        'Last 7 Days': [
          Date.today().add(days: -6)
          'today'
        ]
        'Last 30 Days': [
          Date.today().add(days: -29)
          'today'
        ]
        'This Month': [
          Date.today().moveToFirstDayOfMonth()
          Date.today().moveToLastDayOfMonth()
        ]
        'Last Month': [
          Date.today().moveToFirstDayOfMonth().add(months: -1)
          Date.today().moveToFirstDayOfMonth().add(days: -1)
        ]
      opens: 'left'
      format: 'MM/dd/yyyy'
      separator: ' to '
      startDate: Date.today().add(days: -29)
      endDate: Date.today()
      minDate: '01/01/2012'
      maxDate: '12/31/2013'
      locale:
        applyLabel: 'Submit'
        fromLabel: 'From'
        toLabel: 'To'
        customRangeLabel: 'Custom Range'
        daysOfWeek: [
          'Su'
          'Mo'
          'Tu'
          'We'
          'Th'
          'Fr'
          'Sa'
        ]
        monthNames: [
          'January'
          'February'
          'March'
          'April'
          'May'
          'June'
          'July'
          'August'
          'September'
          'October'
          'November'
          'December'
        ]
        firstDay: 1
      showWeekNumbers: true
      buttonClasses: [ 'btn-danger' ]
    }, (start, end) ->
      $('#reportrange span').html start.toString('MMMM d, yyyy') + ' - ' + end.toString('MMMM d, yyyy')
      return
    #Set the initial state of the picker label
    $('#reportrange span').html Date.today().add(days: -29).toString('MMMM d, yyyy') + ' - ' + Date.today().toString('MMMM d, yyyy')
    return

