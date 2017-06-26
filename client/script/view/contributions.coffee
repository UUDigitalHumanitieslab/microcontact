###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'model/dialects',
	'util/mockupPins'
	'view/contributionList'
], (bb, gmaps, dialects, pins, ContribListView) ->
	'use strict'
	iconSize = 1

	class ContributionsView extends bb.View
		initialize: (options) ->
			@map = options.map
			console.log @map
			@createLookup(dialects)
			@markers = (@createMarker pin for pin in pins)
			console.log @markers
			@popup = new gmaps.InfoWindow
			@contribList = new ContribListView
		createLookup: (dialects) ->
			@dialectsLookup = {}
			@dialectsLookup[dialect["name"]] = dialect for dialect in dialects
			@
		createMarker: (pin) ->
			icon = {
				path: "M-20,0a20,20 0 1,0 40,0a20,20 0 1,0 -40,0",
				fillColor: @dialectsLookup[pin.dialect].color,
				fillOpacity: 0.7,
				anchor: new gmaps.Point(0,0),
				strokeWeight: 0,
				scale: iconSize
			}
			marker = new gmaps.Marker 
				position: pin.position
				title: pin.address
				icon: icon
			marker.addListener 'click', =>
				@popup.setPosition pin.position
				@popup.setContent @contribList.render(pin.address, pin.dialect).el
				@popup.open @map, marker
			marker		
		render: ->
			marker.setMap @map for marker in @markers
			@
		remove: ->
			@popup.close()
			marker.setMap undefined for marker in @markers if @markers
			super()
