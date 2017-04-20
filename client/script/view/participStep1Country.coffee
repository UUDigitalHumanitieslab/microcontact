###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipStep1View extends bb.View
		el: '#particip-step-content'
		template: JST['participStep1Country']
		
		render: ->
			@$el.html @template {}
			@$('#particip-step-title').text '1. Choose your country'
			@
