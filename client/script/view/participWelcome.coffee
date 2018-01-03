define [
	'backbone'
	'plyr'
	'templates'
	'bootstrap/collapse'
], (bb, plyr, JST) ->
	'use strict'
	
	class ParticipWelcomeView extends bb.View
		className: 'panel panel-primary'
		id: 'participate-welcome'
		template: JST['participWelcome']
		
		render: ->
			@$el.html @template {}
			plyr.setup @$('#welcome-video-container').get()
			@
