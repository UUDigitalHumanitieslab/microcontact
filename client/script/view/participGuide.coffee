###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipGuideView extends bb.View
		tagName: 'div'
		className: 'panel panel-primary custom-panel'
		id: 'participate-guide'
		template: JST['participStepContainer']
		
		render: ->
			@$el.html @template {}
			@
