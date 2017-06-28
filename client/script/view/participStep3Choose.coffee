###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipStep3Choose extends bb.View
		template: JST['participStep3Choose']
		
		render: ->
			@$('#particip-step-content').html @template @model.attributes
			@$('#particip-step-title').text '3. Pick your place from the results'
			@
