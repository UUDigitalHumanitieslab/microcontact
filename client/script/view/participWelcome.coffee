define [
	'backbone'
	'templates'
	'bootstrap/collapse'
], (bb, JST) ->
	'use strict'
	
	class ParticipWelcomeView extends bb.View
		className: 'panel panel-primary'
		id: 'participate-welcome'
		template: JST['participWelcome']
		
		render: ->
			@$el.html @template {}
			@
