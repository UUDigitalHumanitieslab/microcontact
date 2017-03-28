###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'util/mockupPins'
], (bb, gmaps, pins) ->
	'use strict'
	
	class ContributionsView extends bb.View
		render: (map) ->
			@markers = (new gmaps.Marker {
				position: pin.position
				title: pin.address
			} for pin in pins) unless @markers
			marker.setMap map for marker in @markers
			console.log @markers
			@
		remove: ->
			marker.setMap undefined for marker in @markers
			super()
