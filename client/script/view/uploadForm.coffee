define [
	'backbone'
	'jquery'
	'underscore'
	'templates'
	'util/dialects'
], (bb, $, _, JST, dialects) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events:
			'click #user-consent': 'updateConsent'
			'submit form': 'submit'
		
		render: (place) ->
			@$el.html @template {place: place.toInternal(), dialects}
			@
		
		submit: (event) ->
			event.preventDefault()
			return unless @consentGiven
			form = @$ 'form'
			form.prop 'disabled', true
			$.ajax
				url: '/api/recordings/'
				type: 'POST'
				data: new FormData form[0]
				cache: false
				contentType: false
				processData: false
				success: => @$el.text 'Grazie!'

		updateConsent: ->
			@consentGiven = @$('#user-consent').prop('checked')
			@$('#submit-button').prop('disabled', !@consentGiven)
