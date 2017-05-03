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
		el: '#particip-step-content'
		template: JST['participStep2Search']
		
		initialize: ->
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
			@model.set query: @query
