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
		template: JST['participStep1Country']
		
		render: ->
			@$('#particip-step-content').html @template {}
			@$('#particip-step-title').text '1. Choose your country'
			@
