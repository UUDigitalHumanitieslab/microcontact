###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'util/mockupPins'
	'view/contributionList'
], (bb, gmaps, pins, ContribListView) ->
	'use strict'
	
	class ContributionsView extends bb.View
		initialize: (options) ->
			@map = options.map
			console.log @map
			@markers = (@createMarker pin for pin in pins)
			console.log @markers
			@popup = new gmaps.InfoWindow
			@contribList = new ContribListView
		createMarker: (pin) ->
			marker = new gmaps.Marker 
				position: pin.position
				title: pin.address
			marker.addListener 'click', =>
				@popup.setPosition pin.position
				@popup.setContent @contribList.render(pin.address).el
				@popup.open @map, marker
			marker
		render: ->
			marker.setMap @map for marker in @markers
			@
		remove: ->
			@popup.close()
			marker.setMap undefined for marker in @markers if @markers
			super()
