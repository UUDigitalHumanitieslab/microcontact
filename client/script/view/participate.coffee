###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'view/participWelcome'
	'view/uploadForm'
], (bb, _, gmaps, ParticipWelcomeView, UploadFormView) ->
	'use strict'
	
	class ParticipateView extends bb.View
		initialize: ->
			@popup = new gmaps.InfoWindow()
			@geocoder = new gmaps.Geocoder maxWidth: 400
			@welcome = new ParticipWelcomeView
			@uploadForm = new UploadFormView
			@welcomePos = gmaps.ControlPosition.TOP_RIGHT
		render: (map) ->
			@remove() if @map
			@map = map
			div = @welcome.render().el
			div.index = 1
			map.controls[@welcomePos].push div
			@clickListener = map.addListener 'click', @handleClick
		remove: ->
			@popup.close()
			gmaps.event.removeListener @clickListener
			@map.controls[@welcomePos].pop() if @map
			delete @map
		handleClick: (event) =>
			@popup.close()
			@popup.setContent ''
			@geocoder.geocode location: event.latLng, @handleGeocode
			@popup.setPosition event.latLng
			@popup.open @map
		handleGeocode: (results, status) =>
			@popup.setContent @uploadForm.render(results, status).el
			if @uploadForm.match
				@popup.setPosition @uploadForm.match.geometry.location
