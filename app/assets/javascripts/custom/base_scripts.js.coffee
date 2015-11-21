window.BaseScripts =
  init: ->
    CommonScripts.accordion()
    CommonScripts.sidebartoogle()
    CommonScripts.sidebarScrollMask()
    CommonScripts.customScrollbar()
    $('fa.tooltips').tooltip()
