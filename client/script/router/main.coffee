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
			$('nav a').click (event) =>
				@navigate ($(event.target).attr 'href'), trigger: true
			@map = mapView.render().map
		routes:
			'(participate)': 'participate'
			'contributions': 'contributions'
		contributions: ->
			participateView.remove()
			contributionsView.render @map
		participate: ->
			contributionsView.remove()
			participateView.render @map
