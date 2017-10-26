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
	acceptedMediaTypes = 'audio/*'
	# The following is a merger of a somewhat arbitrary selection out of
	#  - ffmpeg -codecs
	#  - https://fileinfo.com/filetypes/audio
	#  - https://www.iana.org/assignments/media-types/media-types.xhtml#audio
	# Criterion: name sounds familiar or like it may be associated with voice
	# recorders.
	# Order: most common or most likely to be associated with voice recorders
	# first, otherwise alphabetical. There are three alphabetical subranges.
	acceptedExtensions = 'mp3|mp4|m4a|aac|wav|aiff|aif|aifc|flac|alac|3g2|3gp|3gpp|3ga|amr|gsm|oga|ogg|opus|spx|vmf|vmo|vox|vpm|vpw|vqf|vrf|vsq|vsqx|vyf|aa|aa3|ac3|acm|acp|act|adf|adt|adts|ape|ast|at3|au|awb|boa|caf|caff|cdda|cdr|cpt|dff|dss|dts|dtshd|dvf|dwd|fzv|mp2|ics|iff|isma|la|lwv|mgv|mka|mo3|mpa|mpc|mpga|mpu|msv|narrative|ncw|nvf|odm|ofr|oma|omf|omg|pca|pho|ppc|ppcx|psf|pvc|qcp|r1m|ra|raw|rx2|s3z|ses|sesx|shn|snd|tak|tta|w64|wave|wv|zvd'
	recordingDefaultMessage = 'Carica un file audio di 5 minuti (minimo) fino a
		10 minuti (massimo).'
	recordingMaxSizeMessage = $.validator.format 'Il tuo file è troppo grande.
		Alternativamente, puoi usare un formato compresso, per esempio FLAC,
		oppure puoi ridurre il file in qualità CD (se stai usando risoluzioni
		più avanzate). Puoi anche provare a tagliare i segmenti silenziosi
		della tua registrazione (pause, interruzioni, ecc...) per ottenere un
		file più piccolo di {0}.'

	# Retrieve containing div.form-group, div.radio for form element
	getFormGroupElement = (element) -> $(element).parents('div').first()

	# Toggle classes for form group and glyphicon of a given form field
	setContextFeedback = (field, groupAdd, groupRemove, iconAdd, iconRemove) ->
		getFormGroupElement(field).removeClass(groupRemove).addClass groupAdd
		icon = $(field).siblings('.glyphicon')
		icon.removeClass(iconRemove).addClass iconAdd
		getFormGroupElement(icon).addClass 'has-feedback'

	class UploadFormView extends bb.View
	
		template: JST['uploadForm']

		events:
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
				submitHandler: @submit
				invalidHandler: @handleInvalid
				rules:
					recording:
						maxFileSize: '100 MB'  # ~10 minute PCM at CD quality
						accept:
							param: acceptedMediaTypes
							depends: (elem) =>
								not $.validator.methods.extension.call @validator, $(elem).val(), elem, acceptedExtensions
						# The extension rule is only here as a fallback for
						# browsers that fail to recognize an audio file format.
						# May still fail, since it is impossible to list all
						# existing file extensions.
						extension:
							param: acceptedExtensions
							depends: (elem) =>
								not $.validator.methods.accept.call @validator, $(elem).val(), elem, acceptedMediaTypes
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
						extension: recordingDefaultMessage
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
			@showStatus 'warning', "#{validator.numberOfInvalids()} campi sono
				stati riempiti incorrettamente. Ricontrolla e prova di nuovo."

		highlight: (element, error, valid) ->
			setContextFeedback(
				element, error, valid, 'glyphicon-remove', 'glyphicon-ok'
			)

		unhighlight: (element, error, valid) ->
			setContextFeedback(
				element, valid, error, 'glyphicon-ok', 'glyphicon-remove'
			)

		placeError: (errorLabel, element) ->
			target = getFormGroupElement element
			$(errorLabel).addClass('help-block').appendTo target

		submit: (form, event) =>
			event.preventDefault()
			@setOrigin event
			contribution = new Contribution
			@updateLanguages =>
				contribution.save(form).then(@handleSuccess, @handleError)
				@$('fieldset').prop 'disabled', true
			@showStatus 'info', 'Caricamento in corso. Si prega di attendere...'

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
