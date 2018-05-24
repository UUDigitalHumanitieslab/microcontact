define [
	'backbone'
	'templates'
	'bootstrap/collapse'
], (bb, JST) ->
	'use strict'
	
	class WelcomeView extends bb.View
		className: 'panel panel-primary'
		id: 'welcome'
		template: JST['welcome']
		
		render: ->
			@$el.html @template {}
			@
