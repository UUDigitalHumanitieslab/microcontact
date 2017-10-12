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
	recordingDefaultMessage = 'Carica un file audio di 5 minuti (minimo) fino a
		10 minuti (massimo).'
	recordingMaxSizeMessage = $.validator.format 'Il tuo file è troppo grande.
		Alternativamente, puoi usare un formato compresso, per esempio FLAC,
		oppure puoi ridurre il file in qualità CD (se stai usando risoluzioni
		più avanzate). Puoi anche provare a tagliare i segmenti silenziosi
		della tua registrazione (pause, interruzioni, ecc...) per ottenere un
		file più piccolo di {0}.'
	
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
						maxFileSize: recordingMaxSizeMessage
				errorClass: 'has-error'
				validClass: 'has-success'
				highlight: @highlight
				unhighlight: @unhighlight
				errorPlacement: @placeError
			@firstGenFields = @$ firstGenFieldsSelector
			@firstGenFields.hide()
			@$(generationFieldSelector).hide() unless generationRequired
			@consentGiven = false
			@

		handleInvalid: (event, validator) =>
			@showStatus 'warning', "#{validator.numberOfInvalids()} campi sono
				stati riempiti incorrettamente. Ricontrolla e prova di nuovo."

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
			@showStatus 'info', 'Caricamento in corso. Si prega di attendere...'
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
				@showStatus 'warning', "Alcuni campi non sono validi.
					Ricontrolla. #{wrong.non_field_errors ? ''}"
				@validator.showErrors wrong
			else
				@showStatus 'danger', 'L’invio non è riuscito per problemi
					tecnici. Riprova più tardi. Se il problema continua,
					contatta un membro del gruppo di ricerca.'

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
