window.SkelInit =
	init: (hrefs)->
		hrefs = JsonParser.run(hrefs)
		console.log hrefs[0]
		if hrefs && hrefs.length > 0 && hrefs.length < 7
			skel.init
			  reset: 'full'
			  breakpoints:
			    global:
			      href: hrefs[0]
			      containers: 1400
			      grid: gutters: [
			        '2em'
			        0
			      ]
			    xlarge:
			      media: '(max-width: 1680px)'
			      href: hrefs[1]
			      containers: 1200
			    large:
			      media: '(max-width: 1280px)'
			      href: hrefs[2]
			      containers: 960
			      grid: gutters: [
			        '1.5em'
			        0
			      ]
			      viewport: scalable: false
			    medium:
			      media: '(max-width: 980px)'
			      href: hrefs[3]
			      containers: '90%!'
			    small:
			      media: '(max-width: 736px)'
			      href: hrefs[4]
			      containers: '90%!'
			      grid: gutters: [
			        '1.25em'
			        0
			      ]
			    xsmall:
			      media: '(max-width: 480px)'
			      href: hrefs[5]

			  plugins: layers:
			    config: mode: 'transform'
			    navButton:
			      breakpoints: 'medium'
			      height: '4em'
			      html: '<span class="toggle" data-action="toggleLayer" data-args="navPanel"></span>'
			      position: 'top-left'
			      side: 'top'
			      width: '6em'
			    navPanel:
			      animation: 'overlayX'
			      breakpoints: 'medium'
			      clickToHide: true
			      height: '100%'
			      hidden: true
			      html: '<div data-action="moveElement" data-args="nav"></div>'
			      orientation: 'vertical'
			      position: 'top-left'
			      side: 'left'
			      width: 250

	skel_ops: ->
		[
			{
	      containers: 1400
	      grid: gutters: [
	        '2em'
	        0
	      ]
			},
			{
	      media: '(max-width: 1680px)'
	      containers: 1200
	    },
	    {
	      media: '(max-width: 1280px)'
	      containers: 960
	      grid: gutters: [
	        '1.5em'
	        0
	      ]
	      viewport: scalable: false

	    },
	    {
	      media: '(max-width: 980px)'
	      containers: '90%!'
	    },
	    {
	      media: '(max-width: 736px)'
	      containers: '90%!'
	      grid: gutters: [
	        '1.25em'
	        0
	      ]
	    },
	    {
	      media: '(max-width: 480px)'
	    },

		]

