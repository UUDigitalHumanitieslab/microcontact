define [
	'backbone'
	'jquery'
	'underscore'
	'templates'
	'model/contribution'
	'util/dialects'
	'util/languages'
	'util/ageCategories'
	'select2'
	'jquery.validate'
	'jquery.validate.additions'
], (bb, $, _, JST, Contribution, dialects, languages, ages) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events:
			'click #user-consent': 'updateConsent'
		
		render: (place) ->
			@validator?.destroy()
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
			@validator = @$('form').validate
				submitHandler: @submit
				invalidHandler: @handleInvalid
				rules:
					email:
						require_from_group: [1, '.upload-contact']
					phone:
						require_from_group: [1, '.upload-contact']
				errorClass: 'has-error'
				validClass: 'has-success'
				highlight: @highlight
				unhighlight: @unhighlight
				errorPlacement: @placeError
			@

		handleInvalid: (event, validator) ->
			alert "#{validator.numberOfInvalids()} fields were filled out
				incorrectly. Please review the form and try again."

		highlight: (element, error, valid) ->
			$(element).parent().removeClass(valid).addClass error
			$(element).siblings('.glyphicon').removeClass(
				'glyphicon-ok'
			).addClass(
				'glyphicon-remove'
			).parent().addClass 'has-feedback'

		unhighlight: (element, error, valid) ->
			$(element).parent().removeClass(error).addClass valid
			$(element).siblings('.glyphicon').removeClass(
				'glyphicon-remove'
			).addClass('glyphicon-ok').parent().addClass 'has-feedback'

		placeError: (errorLabel, element) ->
			$(errorLabel).addClass('help-block').appendTo $(element).parent()

		submit: (form, event) =>
			event.preventDefault()
			return unless @consentGiven
			@showStatus 'info', 'Uploading, please wait...'
			contribution = new Contribution
			@updateLanguages =>
				contribution.save(form).then(@handleSuccess, @handleError)
				@$('fieldset').prop 'disabled', true

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

		handleSuccess: (data, statusText, jqXHR) =>
			@showStatus 'success', 'Grazie!'

		handleError: (jqXHR, statusText, thrownError) =>
			@$('fieldset').prop 'disabled', false
			if jqXHR.status == 400 and jqXHR.responseJSON?
				wrong = _.mapValues jqXHR.responseJSON, _.partial _.join, _, ' '
				@showStatus 'warning', "Some of the fields were invalid,
					please review. #{wrong.non_field_errors ? ''}"
				@validator.showErrors wrong
			else
				@showStatus 'danger', 'Submission failed for technical
					reasons. Please try again later. If the problem persists,
					please contact the researcher.'

		# available levels: 'success', 'info', 'warning', 'danger'.
		showStatus: (level, text) =>
			@$('#upload-status').removeClass(
				'alert-success alert-info alert-warning alert-danger'
			).addClass("alert alert-#{level}").attr('role', 'alert').text text

		updateConsent: ->
			@consentGiven = @$('#user-consent').prop('checked')
			@$('#submit-button').prop('disabled', !@consentGiven)
