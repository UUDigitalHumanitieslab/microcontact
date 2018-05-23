###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing
###

define [
	'backbone'
	'jquery'
	'googlemaps'
	'view/enterButtons'
], (bb, $, gmaps, EnterButtons) ->
	'use strict'
	
	class EnterView extends bb.View
		el: 'enter'
		
		initialize: (options) ->
			@map = options.map
			@buttons = new EnterButtons
			@

		render: ->
			console.log('render')
			return @ if @rendered
			@addControl @buttons, gmaps.ControlPosition.TOP_CENTER, 1
			@rendered = true
			@

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div