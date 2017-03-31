define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipInstructView extends bb.View
		tagName: 'div'
		template: JST['participInstruct']
		
		render: ->
			@$el.html @template {}
			@
