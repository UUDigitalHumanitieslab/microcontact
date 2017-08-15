define [
	'backbone'
	'jquery'
	'underscore'
	'templates'
	'util/dialects'
	'util/csrf'
], (bb, $, _, JST, dialects, getCSRFToken) ->
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
			# TODO: we want the following to be a RecordingModel.create.
			# In that case, it should not be necessary to explicitly import/call
			# getCSRFToken, as it will defer to bb.sync, which we have
			# overridden in util/csrf to always include the CSRF token.
			$.ajax
				url: '/api/contributions/'
				type: 'POST'
				data: new FormData form[0]
				headers:
					'X-CSRFToken': getCSRFToken()
				cache: false
				contentType: false
				processData: false
				success: => @$el.text 'Grazie!'

		updateConsent: ->
			@consentGiven = @$('#user-consent').prop('checked')
			@$('#submit-button').prop('disabled', !@consentGiven)
