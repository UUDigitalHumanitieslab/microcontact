###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'templates'
], (bb, _, gmaps, JST) ->
	'use strict'
	
	center =
		lat: -28.699929
		lng: -59.0452857
	zoom = 6
	mapSettings = {center, zoom}
	placeNames = 
		ar: [
			'salta', 'san miguel de tucuman', 'santiago del estero', 'catamarca'
			'cordoba', 'mendoza', 'rio cuarto', 'san luis', 'rosario'
			'santa fe', 'buenos aires', 'la plata'
		]
		br: [
			'santa maria', 'pelotas', 'porto alegre', 'caxias do sul', 'chapeco'
			'florianopolis', 'belneario camboriu', 'joinville', 'curitiba'
			'cascavel', 'maringa', 'londrina', 'dourados'
		]
	places = _.flatten(
		{city, country} for city in list for country, list of placeNames
	)
	console.log places
	addMarker = (self, index) ->
		{city, country} = places[index]
		self.geocoder.geocode {
			address: city
			componentRestrictions: {country}
		}, (results, status) ->
			console.log index, city, country
			switch status
				when 'OK'
					console.log results[0].geometry.location.lat(), results[0].geometry.location.lng()
					self.markers.push new gmaps.Marker
						map: self.map
						position: results[0].geometry.location
						title: city
				else console.log status
		if index + 1 < places.length
			setTimeout addMarker, 1000, self, index + 1
	
	class MapView extends bb.View
		template: JST['map']
		el: 'main'
		render: ->
			@$el.html @template {}
			mapElem = @$ '#map'
			console.log mapElem
			@map = new gmaps.Map mapElem[0], mapSettings
			console.log @map
			@geocoder = new gmaps.Geocoder()
			@markers = []
			addMarker @, 0
			@
