###
	(c) 2017 Digital Humanities Lab, Utrecht University
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
], (bb, gmaps, dialects, places, ContribListView, ContribPie, Welcome) ->
	'use strict'

	class ContributionsView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_LEFT

		initialize: (options) ->
			@map = options.map
			@createLookup(dialects)
			@pies = places.map (place) -> new ContribPie model: place
			@markers = @pies.map @createMarker
			@popup = new gmaps.InfoWindow
			@contribList = new ContribListView
			@welcome = new Welcome
		# Group the contributions by dialects.
		# Returns:
		# 	Array with each element containing { dialect, color, pins[] }
		groupContributionsByDialect: (pins) ->		
			groupedDialects = {}
			addPin = (dialect, pin) ->
				if !groupedDialects[dialect]
					groupedDialects[dialect] = []
				groupedDialects[dialect].push(pin)
			addPin(pin.dialect, pin) for pin in pins
			dialectsLookup = @dialectsLookup
			{
				dialect: dialect,
				color: dialectsLookup[dialect].color,
				pins: groupedDialects[dialect]
			} for dialect in Object.keys(groupedDialects).sort()

		createLookup: (dialects) ->
			@dialectsLookup = {}
			@dialectsLookup[dialect['id']] = dialect for dialect in dialects.toJSON()
			@

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
			marker.addListener 'click', =>
				@popup.setPosition position
				@popup.setContent @contribList.render(
					address,
					@groupContributionsByDialect(place)
				).el
				@popup.open @map, marker
			marker		

		render: ->
			@addControl @welcome, @welcomePos, 1
			marker.setMap @map for marker in @markers
			@

		remove: ->
			@map.controls[@welcomePos].pop()
			@popup.close()
			marker.setMap undefined for marker in @markers if @markers
			super()

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div
