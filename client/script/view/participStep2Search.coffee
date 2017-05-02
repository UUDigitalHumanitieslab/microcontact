###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'collection/googlePlaces'
	'templates'
], (bb, Places, JST) ->
	'use strict'
	
	class ParticipStep2View extends bb.View
		el: '#particip-step-content'
		template: JST['participStep2Search']
		
		initialize: (options) ->
			@map = options.map
			@places = new Places null, @map
			@query = ''
		
		render: ->
			@$el.html @template @model.attributes
			@$('#particip-step-title').text '2. Find your place'
			@
		
		events:
			'change input': 'edit'
			'submit form': 'search'
		
		edit: (event) ->
			@query = $(event.target).val()
		
		search: (event) ->
			event.preventDefault()
			return unless @query.query
			@places.fetch
				method: 'textSearch'
				query:
					query: @query
					types: ['locality']
					bounds: @map.getBounds()
				reset: true
			@places.once 'reset', @showResults
			@places.once 'error', @showError
		
		showResults: =>
			# TODO
		
		showError: =>
			# TODO
