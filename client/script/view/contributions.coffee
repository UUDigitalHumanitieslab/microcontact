###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'util/dialects'
	'util/places'
	'view/contributionList'
	'view/participWelcome'
], (bb, gmaps, dialects, places, ContribListView, Welcome) ->
	'use strict'
	iconSize = 24
	iconOpacity = 0.9
	iconLogScale = 1.1

	class ContributionsView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_LEFT
		pieTemplate: JST['contributionPie']

		initialize: (options) ->
			@map = options.map
			@createLookup(dialects)
			@markers = places.map @createMarker
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
		# Create a pie chart to show the response at a certain location
		bakePie: (place) ->
			totalCount = place.recordings.length
			scale = iconSize * (1 + iconLogScale * Math.log(totalCount))
			dialectsHistogram = place.recordings.countBy 'dialect'
			dialectsLookup = @dialectsLookup

			# convert to list, to make it easily iterable in the template
			x = 1
			y = 0
			
			currentFraction = 0
			updateX = (fraction) ->
				currentFraction += fraction
			
				x = Math.cos(2 * Math.PI * currentFraction)
				y = Math.sin(2 * Math.PI * currentFraction)
				x

			half = totalCount / 2
			getPiePiece = (dialectID) -> {
				dialect: dialectsLookup[dialectID].dialect,
				color: dialectsLookup[dialectID].color,
				fraction: dialectsHistogram[dialectID],
				startX: x,
				startY: y,
				largeArcFlag: if dialectsHistogram[dialectID] > 0.5 then 1 else 0,
				endX: updateX(dialectsHistogram[dialectID]),
				endY: y
			}

			dialects = (getPiePiece(dialect) for dialect of dialectsHistogram)
			
			size = Math.floor(iconSize * (1 + iconLogScale * Math.log(totalCount)))			
			svg = @pieTemplate {dialects, size, opacity: iconOpacity}
			
			# emit the chart
			{
				url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(svg)
				# image is assumed to be 32px wide
				origin: new gmaps.Point(0,0)
				anchor: new gmaps.Point(size / 2, size / 2)
				size: new gmaps.Size(size, size)
			}

		createLookup: (dialects) ->
			@dialectsLookup = {}
			@dialectsLookup[dialect['id']] = dialect for dialect in dialects.toJSON()
			@
		createMarker: (place) =>
			position =
				lat: place.get 'latitude'
				lng: place.get 'longitude'
			address = place.get 'name'
			marker = new gmaps.Marker 
				position: position
				title: address
				icon: @bakePie(place)
			marker.addListener 'click', =>
				@popup.setPosition position
				@popup.setContent @contribList.render(
					address,
					@groupContributionsByDialect(place)).el
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
