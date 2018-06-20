###
	(c) 2017-2018 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp, Sheean Spoel
###

define [
	'backbone'
	'googlemaps'
	'jquery'
	'util/dialects'
	'util/places'
	'view/contributionList'
	'view/contributionPie'
	'view/contributionSearch'
], (bb, gmaps, $, dialects, places, ContribList, ContribPie, ContribSearch) ->
	'use strict'

	class ContributionsView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_LEFT
		searchBoxPos: gmaps.ControlPosition.TOP_LEFT

		initialize: (options) ->
			@map = options.map
			@pies = places.filter((place) ->
				!place.recordings.isEmpty()
			).map (place) -> new ContribPie model: place
			@markers = @pies.map @createMarker
			@popup = new gmaps.InfoWindow
			@contribList = new ContribList
			@contribSearch = new ContribSearch
			

		createMarker: (pie) =>
			place = pie.model
			position =
				lat: place.get 'latitude'
				lng: place.get 'longitude'
			address = place.get 'name'
			marker = new gmaps.Marker
				position: position
				title: address
				icon: pie.render().asIcon()
				optimized: false
			marker.addListener 'click', =>
				@popup.setPosition position
				@popup.setContent @contribList.render(place).el
				@popup.open @map, marker
			marker

		render: ->
			marker.setMap @map for marker in @markers
			@addControl(@contribSearch, @searchBoxPos, 1)
			inputField = @contribSearch.$('#pac-input')[0]
			@autocomplete = new gmaps.places.Autocomplete inputField,
				types: ['geocode']
			@autocomplete.addListener 'place_changed', @focusOnPlace
			@

		remove: ->
			@popup.close()
			@contribList.remove()
			@contribSearch.remove()
			@map.controls[@searchBoxPos].pop()
			marker.setMap undefined for marker in @markers if @markers
			super()

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div

		focusOnPlace: =>
			result = @autocomplete.getPlace()
			if result.geometry and result.geometry.viewport
				# custom zoom level for cities, fit screen for other results
				if 'locality' in result.types
					@map.setCenter(result.geometry.location)
					@map.setZoom(6)  # Why 6? Because it looks good.
				else
					@map.fitBounds(result.geometry.viewport)
			