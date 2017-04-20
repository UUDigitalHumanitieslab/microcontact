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
		className: 'panel panel-default'
		id: 'participate-guide'
		template: JST['participStepsContainer']
		
		render: ->
			@$el.html @template {}
			@
