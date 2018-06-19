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
	'view/contributionLegend'
], (bb, gmaps, dialects, places, ContribList, ContribPie, ContribLegend) ->
	'use strict'

	class ContributionsView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_LEFT
		legendPos: gmaps.ControlPosition.LEFT_BOTTOM

		initialize: (options) ->
			@map = options.map
			@pies = places.filter((place) ->
				!place.recordings.isEmpty()
			).map (place) -> new ContribPie model: place
			@markers = @pies.map @createMarker
			@popup = new gmaps.InfoWindow
			@contribList = new ContribList
			@legend = new ContribLegend collection: dialects

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
			@addControl @legend, @legendPos, 1
			marker.setMap @map for marker in @markers
			@

		remove: ->
			@popup.close()
			@contribList.remove()
			marker.setMap undefined for marker in @markers if @markers
			@legend.$el.popover 'hide'
			@map.controls[@legendPos].pop()
			super()

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div
