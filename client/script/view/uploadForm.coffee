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
	'jquery.validate.messages.IT'
	'util/fileSizeValidators'
], (bb, $, _, JST, Contribution, dialects, languages, ages) ->
	'use strict'
	
	generationFieldSelector = '#upload-generation-field'
	generationFieldValueSelector = "#{generationFieldSelector} input:checked"
	firstGenFieldsSelector = '#upload-firstgen-fields'
	recordingDefaultMessage = 'Please upload an audio file of 5 to 10 minutes.'
	recordingMinSizeMessage = $.validator.format 'Your file is smaller than
		{0}. Are you sure it is the correct recording?'
	recordingMaxSizeMessage = $.validator.format 'Your file is very large.
		Please use a compression format such as FLAC, reduce to CD quality if
		you are using higher settings or try clipping silent segments out of
		your recording, to get the file size under {0}.'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events:
			'click #accept-button': 'submit'
			'submit form': 'setOrigin'
			"change #{generationFieldSelector} input": 'toggleFirstGenFields'
		
		render: (place) ->
			place = place.toInternal()
			generationRequired = (place.country != 'IT')
			@validator?.destroy()
			@$el.html @template {
				place
				dialects: dialects.toJSON()
				languages: languages.toJSON()
				ages: ages.toJSON()
			}
			@$('#upload-languages').select2
				width: '100%'
				tags: true
				tokenSeparators: [',', ' ', '\n']
			@validator = @$('form').validate
				submitHandler: @consent
				invalidHandler: @handleInvalid
				rules:
					recording:
						minFileSize: '100 kB'  # ~2 minute AMR at "tolerable" Q
						maxFileSize: '100 MB'  # ~10 minute PCM at CD quality
					generation:
						required: generationRequired
					migrated:
						required: depends: @isFirstGeneration
					'origin-place':
						required: depends: @isFirstGeneration
					'origin-province':
						required: depends: @isFirstGeneration
					email:
						require_from_group: [1, '.upload-contact']
					phone:
						require_from_group: [1, '.upload-contact']
				messages:
					recording:
						required: recordingDefaultMessage
						accept: recordingDefaultMessage
						minFileSize: recordingMinSizeMessage
						maxFileSize: recordingMaxSizeMessage
				errorClass: 'has-error'
				validClass: 'has-success'
				highlight: @highlight
				unhighlight: @unhighlight
				errorPlacement: @placeError
			@firstGenFields = @$ firstGenFieldsSelector
			@firstGenFields.hide()
			@$(generationFieldSelector).hide() unless generationRequired
			@

		handleInvalid: (event, validator) =>
			@showStatus 'warning', "#{validator.numberOfInvalids()} fields were
				filled out incorrectly. Please review the form and try again."

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

		consent: (form, event) =>
			event.preventDefault()
			if @consentGiven
				@submit(event)
			else
				@$('#upload-form').hide()
				@$('#upload-consent').show()

		submit: (event) ->
			form = @$ 'form'
			contribution = new Contribution
			@updateLanguages =>
				contribution.save(form[0]).then(@handleSuccess, @handleError)
				@$('fieldset').prop 'disabled', true
			@showStatus 'info', 'Uploading, please wait...'
			@$('#upload-consent').hide()
			@$('#upload-form').show()
			@consentGiven = true

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
			@$('.upload-status').removeClass(
				'alert-success alert-info alert-warning alert-danger'
			).addClass("alert alert-#{level}").attr('role', 'alert').text text

		setOrigin: (event) ->
			placeField = @$ '#upload-origin-place'
			maxLength = placeField.prop 'maxlength'
			place = placeField.val()
			province = @$('#upload-origin-province').val()
			@$('#upload-origin').val "#{
				place.slice 0, maxLength - province.length - 2
			}, #{province}"

		isFirstGeneration: => $(generationFieldValueSelector).val() == 'a'

		toggleFirstGenFields: (event) ->
			if @isFirstGeneration() # Born in Italy
				@firstGenFields.show()
			else
				@firstGenFields.hide()
