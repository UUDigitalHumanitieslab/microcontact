###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'view/map'
	'view/contributions'
	'view/participate'
	'bootstrap/tab'
], (bb, MapView, ContributionsView, ParticipateView) ->
	'use strict'
	
	mapView = new MapView
	contributionsView = new ContributionsView
	participateView = new ParticipateView
	
	class MainRouter extends bb.Router
		routes:
			'(home)': 'contributions'
			'participate': 'participate'
		map: -> mapView.map or mapView.render().map
		contributions: ->
			contributionsView.render @map()
		participate: ->
			contributionsView.remove()
			participateView.render @map()
