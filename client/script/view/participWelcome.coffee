define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipWelcomeView extends bb.View
		tagName: 'div'
		className: 'panel panel-default'
		id: 'participate-welcome'
		template: JST['participWelcome']
		
		render: ->
			@$el.html @template {}
			@
