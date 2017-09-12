###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'util/dialects'
	'util/mockupPins'
	'view/contributionList'
	'view/participWelcome'
], (bb, gmaps, dialects, pins, ContribListView, Welcome) ->
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
			groupedPins = @groupContributionsByAddress(pins)
			@markers = (@createMarker groupedPins[address] for address in Object.keys(groupedPins))
			@popup = new gmaps.InfoWindow
			@contribList = new ContribListView
			@welcome = new Welcome
		groupContributionsByAddress: (pins) ->
			addresses = {}
			addPin = (address, pin) ->
				if !addresses[address]
					addresses[address] = []
				addresses[address].push(pin)
			addPin(pin.address, pin) for pin in pins
			addresses
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
		bakePie: (pins) ->
			scale = iconSize * (1 + iconLogScale * Math.log(pins.length))
			dialectsHistogram = {}
			dialectsLookup = @dialectsLookup
			countDialect = (pin) ->
				if (!dialectsHistogram[pin.dialect])
					dialectsHistogram[pin.dialect] = { count: 0, fraction: 0 }
				dialectsHistogram[pin.dialect].count++
				# TODO: this should be done more efficiently
				dialectsHistogram[pin.dialect].fraction = dialectsHistogram[pin.dialect].count / pins.length
			countDialect(pin) for pin in pins

			# convert to list, to make it easily iterable in the template
			x = 1
			y = 0
			
			currentFraction = 0
			updateX = (fraction) ->
				currentFraction += fraction
			
				x = Math.cos(2 * Math.PI * currentFraction)
				y = Math.sin(2 * Math.PI * currentFraction)
				x

			half = pins.length / 2
			getPiePiece = (dialect) -> {
				dialect: dialect,
				color: dialectsLookup[dialect].color,
				fraction: dialectsHistogram[dialect].fraction,
				startX: x,
				startY: y,
				largeArcFlag: if dialectsHistogram[dialect].fraction > 0.5 then 1 else 0,
				endX: updateX(dialectsHistogram[dialect].fraction),
				endY: y
			}

			dialects = (getPiePiece(dialect) for dialect in Object.keys(dialectsHistogram))
			
			size = Math.floor(iconSize * (1 + iconLogScale * Math.log(pins.length)))			
			svg = @pieTemplate {dialects, size, opacity: iconOpacity}
			
			# emit the chart
			{
				url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(svg)
				# image is assumed to be 32px wide
				origin: new gmaps.Point(0,0)
				anchor: new gmaps.Point(size/2, size/2)
				size: new gmaps.Size(size, size)
			}

		createLookup: (dialects) ->
			@dialectsLookup = {}
			@dialectsLookup[dialect["name"]] = dialect for dialect in dialects
			@
		createMarker: (pins) ->
			pin = pins[0]			
			marker = new gmaps.Marker 
				position: pin.position
				title: pin.address
				icon: @bakePie(pins)
			marker.addListener 'click', =>
				@popup.setPosition pin.position
				@popup.setContent @contribList.render(
					pin.address, 
					@groupContributionsByDialect(pins)).el
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
