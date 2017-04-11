###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'view/participInstruct'
	'view/uploadForm'
], (bb, _, gmaps, ParticipInstructView, UploadFormView) ->
	'use strict'
	
	class ParticipateView extends bb.View
		initialize: ->
			@popup = new gmaps.InfoWindow()
			@geocoder = new gmaps.Geocoder maxWidth: 400
			@instructions = new ParticipInstructView
			@uploadForm = new UploadFormView
			@ctrlPos = gmaps.ControlPosition.TOP_RIGHT
		render: (map) ->
			@remove() if @map
			@map = map
			div = @instructions.render().el
			div.index = 1
			map.controls[@ctrlPos].push div
			@clickListener = map.addListener 'click', @handleClick
		remove: ->
			@popup.close()
			gmaps.event.removeListener @clickListener
			@map.controls[@ctrlPos].pop() if @map
			delete @map
		handleClick: (event) =>
			@popup.close()
			@popup.setContent ''
			@geocoder.geocode location: event.latLng, @handleGeocode
			@popup.setPosition event.latLng
			@popup.open @map
		handleGeocode: (results, status) =>
			console.log results
			@popup.setContent @uploadForm.render(results, status).el
			if @uploadForm.match
				@popup.setPosition @uploadForm.match.geometry.location
			else
				@popup.close()
				@giveOptionsNear @popup.getPosition()
		giveOptionsNear: (position) ->
			places = new gmaps.places.PlacesService @map
			request =
				location: position
				radius: 50000
				# rankBy: gmaps.places.RankBy.DISTANCE
				types: ['locality']
			places.radarSearch request, (results, status) =>
				for place in results
					marker = new gmaps.Marker
						position: place.geometry.location
						map: @map
					marker.addListener 'click', @handleClick
					remove = @map.addListener 'click', ->
						marker.setMap undefined
						gmaps.event.removeListener remove
			@map.setCenter position
			@map.setZoom (@map.getZoom() + 2)
