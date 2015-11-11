window.GitterConf =
  init: ->
    if CommonScripts.gritter_image_url
      $('#add-sticky').click ->
        unique_id = $.gritter.add(
          title: 'This is a Sticky Notice!'
          text: 'Hover me to enable the Close Button. This note also contains a link example. Thank you so much to try Dashgum. Developed by <a href="#" style="color:#FFD777">Alvarez.is</a>.'
          image: CommonScripts.gritter_image_url
          sticky: true
          time: ''
          class_name: 'my-sticky-class')
        false
      # You can have it return a unique id, this can be used to manually remove it later using

      ###
        setTimeout(function(){

          $.gritter.remove(unique_id, {
            fade: true,
            speed: 'slow'
          });

        }, 6000)
      ###

      $('#add-regular').click ->
        $.gritter.add
          title: 'This is a Regular Notice!'
          text: 'This will fade out after a certain amount of time. This note also contains a link example. Thank you so much to try Dashgum. Developed by <a href="#" style="color:#FFD777">Alvarez.is</a>.'
          image: CommonScripts.gritter_image_url
          sticky: false
          time: ''
        false

      $('#add-max').click ->
        $.gritter.add
          title: 'This is a notice with a max of 3 on screen at one time!'
          text: 'This will fade out after a certain amount of time. This note also contains a link example. Thank you so much to try Dashgum. Developed by <a href="#" style="color:#FFD777">Alvarez.is</a>.'
          image: CommonScripts.gritter_image_url
          sticky: false
          before_open: ->
            if $('.gritter-item-wrapper').length == 3
              # Returning false prevents a new gritter from opening
              return false
            return
        false

    $('#add-without-image').click ->
      $.gritter.add
        title: 'This is a Notice Without an Image!'
        text: 'This will fade out after a certain amount of time. This note also contains a link example. Thank you so much to try Dashgum. Developed by <a href="#" style="color:#FFD777">Alvarez.is</a>.'
      false

    $('#add-gritter-light').click ->
      $.gritter.add
        title: 'This is a Light Notification'
        text: 'Just add a "gritter-light" class_name to your $.gritter.add or globally to $.gritter.options.class_name'
        class_name: 'gritter-light'
      false

    $('#remove-all').click ->
      $.gritter.removeAll()
      false

