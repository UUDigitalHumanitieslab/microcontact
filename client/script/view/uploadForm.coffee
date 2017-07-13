define [
	'backbone'
	'underscore'
	'templates'
], (bb, _, JST) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events: 'click #user-consent': 'activate'
		
		render: (place) ->
			data = {}
			country = _.find place.get('address_components'), (component) ->
				'country' in component.types
			data.country = country.short_name
			data.city = place.get('address_components')[0].long_name
			console.log data
			@$el.html @template data
			@
		
		activate: ->
			if @$('#user-consent').prop('checked')
				@$('#submit-button').prop('disabled', false)
			else
				@$('#submit-button').prop('disabled', true)
