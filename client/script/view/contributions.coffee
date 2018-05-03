###
	(c) 2017-2018 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp, Sheean Spoel
###

define [
	'backbone'
	'googlemaps'
	'util/dialects'
	'util/places'
	'view/contributionList'
	'view/contributionPie'
	'view/participWelcome'
], (bb, gmaps, dialects, places, ContribList, ContribPie, Welcome) ->
	'use strict'

	class ContributionsView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_LEFT

		initialize: (options) ->
			@map = options.map
			@pies = places.filter((place) ->
				!place.recordings.isEmpty()
			).map (place) -> new ContribPie model: place
			@markers = @pies.map @createMarker
			@popup = new gmaps.InfoWindow
			@contribList = new ContribList
			@welcome = new Welcome

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
			@addControl @welcome, @welcomePos, 1
			marker.setMap @map for marker in @markers
			@

		remove: ->
			@map.controls[@welcomePos].pop()
			@popup.close()
			@contribList.remove()
			marker.setMap undefined for marker in @markers if @markers
			super()

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div
