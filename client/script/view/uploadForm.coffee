define [
	'backbone'
	'jquery'
	'underscore'
	'templates'
	'util/dialects'
	'util/languages'
	'util/ageCategories'
	'util/csrf'
	'select2'
], (bb, $, _, JST, dialects, languages, ages, getCSRFToken) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events:
			'click #user-consent': 'updateConsent'
			'submit form': 'submit'
		
		render: (place) ->
			@$el.html @template {
				place: place.toInternal()
				dialects: dialects.toJSON()
				languages: languages.toJSON()
				ages: ages.toJSON()
			}
			@$('#upload-languages').select2
				width: '100%'
				tags: true
				tokenSeparators: [',', ' ', '\n']
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
			@updateLanguages => $.ajax
				url: '/api/recordings/'
				type: 'POST'
				data: new FormData form[0]
				headers:
					'X-CSRFToken': getCSRFToken()
				cache: false
				contentType: false
				processData: false
				success: => @$el.text 'Grazie!'

		updateLanguages: (callback) ->
			chosenLanguages = @$('#upload-languages').select2 'data'
			newLanguages = (
				# preexisting languages have a numerical id, new ones don't
				lang for lang in chosenLanguages when lang.id == lang.text
			)
			newLanguageCount = newLanguages.length
			callback() if newLanguageCount == 0
			for {text, element} in newLanguages
				newModel = languages.add language: text
				newModel.save().done(
					(data) => $(element).val data.id
				).fail(
					=> $(element).remove()
				).always =>
					@$('#upload-languages').trigger 'change.select2'
					if --newLanguageCount == 0
						callback()

		updateConsent: ->
			@consentGiven = @$('#user-consent').prop('checked')
			@$('#submit-button').prop('disabled', !@consentGiven)
