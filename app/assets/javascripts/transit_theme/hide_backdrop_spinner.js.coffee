window.HideBackdropSpinner =
  init: () ->
    setTimeout (->
      $(".js-landing-backdrop").remove()
    ), 2000
