###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'view/map'
], (bb, MapView) ->
	'use strict'
	
	mapView = new MapView
	
	class MainRouter extends bb.Router
		routes:
			'': 'map'
		map: -> mapView.render()
