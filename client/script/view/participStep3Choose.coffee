###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
	'util/i18nText'
], (bb, JST, i18n) ->
	'use strict'
	
	class ParticipStep3Choose extends bb.View
		template: JST['participStep3Choose']
		
		render: ->
			@$('#particip-step-content').html @template @model.attributes
			@$('#particip-step-title').text i18n.pickPlaceTitle
			@
