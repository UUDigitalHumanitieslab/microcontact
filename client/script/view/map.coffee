###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'templates'
	'util/mockupPins'
], (bb, _, gmaps, JST, pins) ->
	'use strict'
	
	center =
		lat: -28.699929
		lng: -59.0452857
	zoom = 6
	mapSettings = {center, zoom}
	console.log pins
	
	class MapView extends bb.View
		template: JST['map']
		el: 'main'
		render: ->
			@$el.html @template {}
			mapElem = @$ '#map'
			console.log mapElem
			@map = new gmaps.Map mapElem[0], mapSettings
			console.log @map
			@markers = (new gmaps.Marker {
				map: @map
				position: pin.position
				title: pin.address
			} for pin in pins)
			console.log @markers
			@
