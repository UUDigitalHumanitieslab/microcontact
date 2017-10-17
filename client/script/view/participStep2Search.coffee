###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
	'googlemaps'
], (bb, JST, gmaps) ->
	'use strict'
	
	class ParticipStep2View extends bb.View
		template: JST['participStep2Search']
		templateMiss: JST['participStep2SearchMiss']
		templateError: JST['participStep2SearchError']
		isRendered: false

		initialize: ->
			@query = ''
		
		render: ->
			@$('#particip-step-content').html @template @model.attributes
			@$('#particip-step-title').text 'Trova la località'
			inputField = @$ '#particip-query'
			inputField.focus()
			@autocomplete = new gmaps.places.Autocomplete inputField[0],
				types: ['(cities)']
				componentRestrictions: country: @model.get 'country'
			@autocomplete.addListener 'place_changed', @select
			@isRendered = true
			@
		
		renderMiss: ->
			if !@isRendered
				@render()
			@$('#particip-step-content').append @templateMiss @model.attributes
			@
		
		renderError: (error) ->
			if !@isRendered
				@render()
			@$('#particip-step-content').append @templateError {error}
			@
		
		events:
			'change input': 'edit'
			'submit form': 'search'
		
		edit: (event) ->
			@query = $(event.target).val()
		
		search: (event) ->
			event.preventDefault()
			@model.set query: @query
		
		select: =>
			result = @autocomplete.getPlace()
			@model.set
				result: result
				query: result.name
