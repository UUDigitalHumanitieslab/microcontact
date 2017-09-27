###
	(c) 2016 Julian Gonggrijp
###

require.config
	baseUrl: 'static/script'
	paths:
		jquery: '../bower_components/jquery/dist/jquery'
		backbone: '../bower_components/backbone/backbone'
		underscore: '../bower_components/lodash/dist/lodash'
		'handlebars.runtime': '../bower_components/handlebars/handlebars.runtime.amd'
		bootstrap: '../bower_components/bootstrap-sass/assets/javascripts/bootstrap'
		async: '../bower_components/requirejs-plugins/src/async'
		'js.cookie': '../bower_components/js-cookie/src/js.cookie'
		select2: '../bower_components/select2/dist/js/select2'
		'jquery.validate': '../bower_components/jquery-validation/dist/jquery.validate'
		'jquery.validate.additions': '../bower_components/jquery-validation/dist/additional-methods'
	shim:
		'bootstrap/transition': ['jquery']
		'bootstrap/modal': ['jquery']      # has own CSS component
		'bootstrap/dropdown': ['jquery']
		'bootstrap/scrollspy': ['jquery']  # needs CSS nav component
		'bootstrap/tab': ['jquery']        # needs CSS nav component
		'bootstrap/tooltip': ['jquery']    # opt-in, has own CSS component
		'bootstrap/popover': [             # opt-in, has own CSS component
			'jquery'
			'bootstrap/tooltip'
		]
		'bootstrap/alert': ['jquery']
		'bootstrap/button': ['jquery']
		'bootstrap/collapse': [
			'jquery'
			'bootstrap/transition'
		]
		'bootstrap/carousel': ['jquery']   # has own CSS component
		'bootstrap/affix': ['jquery']

