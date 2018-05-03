###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'jquery'
	'googlemaps'
	'templates'
], (bb, $, gmaps, JST) ->
	'use strict'
	
	center =
		lat:  42
		lng:   6
	zoom = 4
	mapSettings = {
		center
		zoom
		mapTypeId: 'terrain'
		streetViewControl: false
		mapTypeControl: false
	}
	# Fit Italy-in-context into the viewport.
	bounds =
		north:  48
		east:   19
		south:  36
		west:   -7
	
	class MapView extends bb.View
		logoPos: gmaps.ControlPosition.BOTTOM_LEFT
		template: JST['map']
		el: 'main'
		render: ->
			return @ if @rendered
			@$el.html @template {}
			mapElem = @$ '#map'
			@map = new gmaps.Map mapElem[0], mapSettings
			@map.fitBounds bounds
			@addLogo 'logoERC', 1
			@addLogo 'logoLab', 2
			@rendered = true
			@

		addLogo: (templateName, index, data = {}) ->
			template = JST[templateName]
			logo = $('<div>').html(template data)[0]
			logo.index = index
			@map.controls[@logoPos].push logo
