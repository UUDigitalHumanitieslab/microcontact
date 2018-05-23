###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing
###

define [
	'backbone'
	'jquery'
	'googlemaps'
	'templates'
], (bb, $, gmaps, JST) ->
	'use strict'

	class EnterButtonsView extends bb.View
		id: 'enterButtons'
		template: JST['enterButtons']
		
		render: ->
			return @ if @rendered
			@$el.html @template {}
			@rendered = true
			@