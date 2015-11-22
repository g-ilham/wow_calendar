window.CommonScripts =
  init: (gritter_image_url)->
    self = CommonScripts
    self.gritter_image_url = JsonParser.run(gritter_image_url)
    self.accordion()
    self.sidebartoogle()
    self.sidebarScrollMask()
    self.customScrollbar()
    self.widgetTools()
    self.tooltips_and_popovers()
    self.customBarChat()
    self.popoversConf()
    self.zabuto_calendar()
    self.init_gritter()

  responsiveView: ->
    wSize = $(window).width()
    if wSize <= 768
      $('#container').addClass 'sidebar-close'
      $('#sidebar > ul').hide()
    if wSize > 768
      $('#container').removeClass 'sidebar-close'
      $('#sidebar > ul').show()
    return

  sidebartoogle: ->
    #sidebar toggle
    CommonScripts.responsiveView()
    $(window).resize ->
      CommonScripts.responsiveView()

    $(document).on 'click', '.fa-bars', ->
      if $('#sidebar > ul').is(':visible') == true
        $('#main-content').css 'margin-left': '0px'
        $('#sidebar').css 'margin-left': '-210px'
        $('#container').addClass 'sidebar-closed'
        $(window).trigger("resize")
        $('#sidebar > ul').hide()
      else
        $('#main-content').css 'margin-left': '210px'
        $('#sidebar').css 'margin-left': '0'
        $('#container').removeClass 'sidebar-closed'
        $(window).trigger("resize")
        $('#sidebar > ul').show()
      return

  accordion: ->
    $('#nav-accordion').dcAccordion
      eventType: 'click'
      autoClose: true
      saveState: true
      disableLink: true
      speed: 'slow'
      showCount: false
      autoExpand: true
      classExpand: 'dcjq-current-parent'

  sidebarScrollMask: ->
    #    sidebar dropdown menu auto scrolling
    $(document).on 'click', '#sidebar .sub-menu > a', ->
      o = $(this).offset()
      diff = 250 - (o.top)
      if diff > 0
        $('#sidebar').scrollTo '-=' + Math.abs(diff), 500
      else
        $('#sidebar').scrollTo '+=' + Math.abs(diff), 500
      return

  customScrollbar: ->
    # custom scrollbar
    $('#sidebar').niceScroll
      styler: 'fb'
      cursorcolor: '#4ECDC4'
      cursorwidth: '3'
      cursorborderradius: '10px'
      background: '#404040'
      spacebarenabled: false
      cursorborder: ''

    $('html').niceScroll
      styler: 'fb'
      cursorcolor: '#4ECDC4'
      cursorwidth: '6'
      cursorborderradius: '10px'
      background: '#404040'
      spacebarenabled: false
      cursorborder: ''
      zindex: '1000'

  widgetTools: ->
    # widget tools
    $(document).on 'click', '.panel .tools .fa-chevron-down', ->
      el = $(@).parents('.panel').children('.panel-body')
      if $(@).hasClass('fa-chevron-down')
        $(@).removeClass('fa-chevron-down').addClass 'fa-chevron-up'
        el.slideUp 200
      else
        $(@).removeClass('fa-chevron-up').addClass 'fa-chevron-down'
        el.slideDown 200
      return

    $('.panel .tools .fa-times').click ->
      $(@).parents('.panel').parent().remove()
      return

  tooltips_and_popovers: ->
    #    tool tips
    $('fa.tooltips').tooltip()
    #    popovers
    $('.popovers').popover()

  customBarChat: ->
    # custom bar chart
    if $('.custom-bar-chart')
      $.each $('.bar'), (index, element) ->
        percent = $.trim($(element).find('.value').html())
        $(element).find('.value').html ''
        $(element).find('.value').animate {
          height: percent
        }, 2000

  zabuto_calendar: ->
    $('#my-calendar').zabuto_calendar
      action: ->
        CommonScripts.myDateFunction(@id, false)
      action_nav: ->
        CommonScripts.myNavFunction(@id)
      legend: [
        {
          type: 'text'
          label: 'Special event'
          badge: '00'
        }
        {
          type: 'block'
          label: 'Regular event'
        }
      ]

  myNavFunction: (id)->
    $('#date-popover').hide()
    nav = $('#' + id).data('navigation')
    to = $('#' + id).data('to')
    console.log 'nav ' + nav + ' to: ' + to.month + '/' + to.year
    return

  init_gritter: ->
    if CommonScripts.gritter_image_url
      $.gritter.add(
        title: 'Welcome to Dashgum!'
        text: 'Hover me to enable the Close Button. You can hide the left sidebar clicking on the button next to the logo. Free version for <a href="http://blacktie.co" target="_blank" style="color:#ffd777">BlackTie.co</a>.'
        image: CommonScripts.gritter_image_url
        sticky: true
        time: ''
        class_name: 'my-sticky-class')
    return

  popoversConf: ->
    $('#date-popover').popover
      html: true
      trigger: 'manual'

    $('#date-popover').hide()
    $(document).on 'click', '#date-popover', ->
      $(this).hide()
      return

  doughnut_data_dashboard: ->
    [
      {
        element: document.getElementById('serverstatus01'),
        value: 70
        color: '#68dff0'
      },
      {
        element: document.getElementById('serverstatus01'),
        value: 30
        color: '#fdfdfd'
      },
      {
        element: document.getElementById('serverstatus02'),
        value: 60
        color: '#68dff0'
      },
      {
        element: document.getElementById('serverstatus02'),
        value: 40
        color: '#444c57'
      }
    ]

  doughnut_data_panels: ->
    [
      {
        element: document.getElementById("serverstatus01"),
        value: 70,
        color:"#FF6B6B"
      },
      {
        element: document.getElementById("serverstatus01"),
        value : 30,
        color : "#fdfdfd"
      },
      {
        element: document.getElementById("serverstatus02"),
        value: 60,
        color:"#1c9ca7"
      },
      {
        element: document.getElementById("serverstatus02"),
        value : 40,
        color : "#f68275"
      },
      {
        element: document.getElementById("serverstatus03"),
        value: 60,
        color:"#2b2b2b"
      },
      {
        element: document.getElementById("serverstatus03"),
        value : 40,
        color : "#fffffd"
      }
    ]

  animate_doughnuts: (doughnutData)->
    if doughnutData
      pairsLen = 2
      for index in [0...doughnutData.length] by pairsLen
        pairs = doughnutData[index...index + pairsLen]
        data = CommonScripts.clean_pairs(pairs)
        new Chart(window.doughnut_el.getContext('2d')).Doughnut(data)

    window.doughnut_el = undefined

  clean_pairs: (pairs)->
    $.map(pairs, (element, index) ->
      window.doughnut_el = element['element']
      delete element['element']
      element
    )
