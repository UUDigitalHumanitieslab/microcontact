define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipInstructView extends bb.View
		tagName: 'div'
		className: 'panel panel-default'
		id: 'participate-instructions'
		template: JST['participInstruct']
		
		render: ->
			@$el.html @template {}
			@
