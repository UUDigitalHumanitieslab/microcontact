###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
	'templates'
], (bb, gmaps, JST) ->
	'use strict'
	
	class ParticipStep2View extends bb.View
		el: '#particip-step-content'
		template: JST['participStep2Search']
		
		initialize: (options) ->
			@map = options.map
			@places = new gmaps.places.PlacesService @map
			@query = types: ['locality']
		
		render: ->
			@$el.html @template @model.attributes
			@$('#particip-step-title').text '2. Find your place'
			@
		
		events:
			'change input': 'edit'
			'submit form': 'search'
		
		edit: (event) ->
			@query.query = $(event.target).val()
		
		search: (event) ->
			event.preventDefault()
			return unless @query.query
			@places.textSearch @query, @handleResults
		
		handleResults: (result, status) =>
			# TODO
