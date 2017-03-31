###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'view/participInstruct'
], (bb, _, gmaps, ParticipInstructView) ->
	'use strict'
	
	class ParticipateView extends bb.View
		initialize: ->
			@popup = new gmaps.InfoWindow()
			@geocoder = new gmaps.Geocoder maxWidth: 400
			@instructions = new ParticipInstructView
			@ctrlPos = gmaps.ControlPosition.TOP_RIGHT
		render: (map) ->
			@remove() if @map
			@map = map
			div = @instructions.render().el
			div.index = 1
			map.controls[@ctrlPos].push div
			@clickListener = map.addListener 'click', @handleClick
		remove: ->
			@popup.close()
			gmaps.event.removeListener @clickListener
			@map.controls[@ctrlPos].pop() if @map
			delete @map
		handleClick: (event) =>
			@popup.close()
			@popup.setContent ''
			@geocoder.geocode location: event.latLng, @handleGeocode
			@popup.setPosition event.latLng
			@popup.open @map
		handleGeocode: (results, status) =>
			switch status
				when 'OK'
					cityMatches = _.filter results, (r) -> 'locality' in r.types
					if cityMatches.length
						match = cityMatches[0]
						city = match.address_components[0]
						country = _.filter match.address_components, (c) ->
							'country' in c.types
						@popup.setPosition match.geometry.location
						@popup.setContent "#{city.long_name}, #{country[0].short_name}"
					else
						@popup.setContent "No city here..."
				else
					@popup.setContent "#{status}<br>#{JSON.stringify results}"
