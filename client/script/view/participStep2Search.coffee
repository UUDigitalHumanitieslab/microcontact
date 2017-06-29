###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ParticipStep2View extends bb.View
		template: JST['participStep2Search']
		templateMiss: JST['participStep2SearchMiss']
		templateError: JST['participStep2SearchError']
		
		initialize: ->
			@query = ''
		
		render: ->
			@$('#particip-step-content').html @template @model.attributes
			@$('#particip-step-title').text '2. Find your location'
			@
		
		renderMiss: ->
			@$('#particip-step-content').append @templateMiss @model.attributes
			@
		
		renderError: (error) ->
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
