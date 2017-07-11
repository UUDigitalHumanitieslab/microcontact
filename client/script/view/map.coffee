###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'templates'
], (bb, gmaps, JST) ->
	'use strict'
	
	center =
		lat:   7.5
		lng: -96
	zoom = 3
	mapSettings = {
		center
		zoom
		mapTypeId: 'terrain'
		streetViewControl: false
		mapTypeControl: false
	}
	# Below is a cropped union of geometry.viewport for Canada and Argentina.
	bounds =
		north:  60
		east:  -50
		south: -50
		west: -142
	
	class MapView extends bb.View
		template: JST['map']
		el: 'main'
		render: ->
			@$el.html @template {}
			mapElem = @$ '#map'
			@map = new gmaps.Map mapElem[0], mapSettings
			@map.fitBounds bounds
			@
