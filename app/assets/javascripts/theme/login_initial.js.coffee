window.LoginInitial =
  init: (background_image_url)->
    background_image_url = JsonParser.run(background_image_url)
    $.backstretch(background_image_url, {speed: 500}) if background_image_url
