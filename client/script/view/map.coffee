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
		lat: -28.699929
		lng: -59.0452857
	zoom = 6
	mapSettings = {center, zoom, mapTypeId: 'terrain'}
	
	class MapView extends bb.View
		template: JST['map']
		el: 'main'
		render: ->
			@$el.html @template {}
			mapElem = @$ '#map'
			@map = new gmaps.Map mapElem[0], mapSettings
			@
