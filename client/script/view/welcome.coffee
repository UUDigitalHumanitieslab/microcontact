define [
	'backbone'
	'templates'
	'bootstrap/collapse'
], (bb, JST) ->
	'use strict'
	
	class WelcomeView extends bb.View
		className: 'panel panel-primary custom-panel'
		id: 'welcome'
		template: JST['welcome']
		
		render: ->
			@$el.html @template {}
			@
