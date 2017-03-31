###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'jquery'
	'view/map'
	'view/contributions'
	'view/participate'
	'bootstrap/tab'
], (bb, $, MapView, ContributionsView, ParticipateView) ->
	'use strict'
	
	mapView = new MapView
	contributionsView = new ContributionsView
	participateView = new ParticipateView
	
	class MainRouter extends bb.Router
		initialize: ->
			@map = mapView.render().map
		routes:
			'(participate)': 'participate'
			'contributions': 'contributions'
		contributions: ->
			participateView.remove()
			contributionsView.render @map
			$('nav a[href="#contributions"]').tab 'show'
		participate: ->
			contributionsView.remove()
			participateView.render @map
			$('nav a[href="#participate"]').tab 'show'
