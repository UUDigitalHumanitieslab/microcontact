###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'view/map'
	'view/contributions'
	'bootstrap/tab'
], (bb, MapView, ContributionsView) ->
	'use strict'
	
	mapView = new MapView
	contributionsView = new ContributionsView
	
	class MainRouter extends bb.Router
		routes:
			'(home)': 'contributions'
		map: -> mapView.map or mapView.render().map
		contributions: ->
			contributionsView.render @map()
