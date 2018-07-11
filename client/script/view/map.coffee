###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'jquery'
	'googlemaps'
], (bb, $, gmaps) ->
	'use strict'

	center =
		lat:   5
		lng: -61
	zoom = 3
	mapSettings = {
		center
		zoom
		mapTypeId: 'terrain'
		streetViewControl: false
		mapTypeControl: false
	}
	# Fit both Italy and America on the map.
	bounds =
		north:  60
		east:   19
		south: -50
		west: -142

	class MapView extends bb.View
		logoPos: gmaps.ControlPosition.BOTTOM_LEFT
		id: 'map'

		render: ->
			return @ if @rendered
			@map = new gmaps.Map @el, mapSettings
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
