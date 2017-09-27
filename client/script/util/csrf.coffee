###
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'js.cookie'
], (bb, Cookies) ->
	'use strict'
	
	syncImplementation = bb.sync
	
	getCSRFToken = -> Cookies.get 'csrftoken'
	
	bb.sync = (method, model, options) ->
		unless method == 'read'
			options.headers ?= {}
			options.headers['X-CSRFToken'] = getCSRFToken()
		syncImplementation method, model, options
	
	getCSRFToken
