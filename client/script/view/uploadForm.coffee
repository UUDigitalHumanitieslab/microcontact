define [
	'backbone'
	'jquery'
	'underscore'
	'templates'
	'model/contribution'
	'util/i18nText'
	'util/dialects'
	'util/languages'
	'util/ageCategories'
	'select2'
	'jquery.validate'
	'jquery.validate.additions'
	'i18n!nls/validation'
	'util/fileSizeValidators'
], (bb, $, _, JST, Contribution, i18n, dialects, languages, ages) ->
	'use strict'

	generationFieldSelector = '#upload-generation-field'
	generationFieldValueSelector = "#{generationFieldSelector} input:checked"
	firstGenFieldsSelector = '#upload-firstgen-fields'
	uploaderRelationFieldSelector = '#uploader-relation-field'
	uploaderRelationFieldValueSelector = "#{uploaderRelationFieldSelector} input:checked"
	specifyRelationFieldsSelector = '#upload-specify-relation-fields'
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
	recordingDefaultMessage = i18n.recordingGeneralError
	recordingMaxSizeMessage = $.validator.format i18n.recordingMaxSizeError

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
			"change #{uploaderRelationFieldSelector} input": 'toggleSpecifyRelationField'

		render: (place) ->
			place = place.toInternal()
			fromItaly = (place.country == 'IT')
			@validator?.destroy()
			@$el.html @template {
				place, fromItaly
				dialects: dialects.toJSON()
				languages: languages.toJSON()
				ages: ages.toJSON()
			}
			@$('#upload-languages').select2
				width: '100%'
				tokenSeparators: [',', ' ', '\n']
				placeholder: i18n.otherLanguagesPlaceholder
			# Workaround for a bug that causes the placeholder to be invisible,
			# see https://github.com/select2/select2/issues/155#issuecomment-243093331
			@$('.select2-search__field').css width: ''
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
						required: true
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
					'uploader-relation':
						required: true
					'relation_to_speaker':
						required: depends: @uploaderIsNotRecordee
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
			@specifyRelationFields = @$ specifyRelationFieldsSelector
			@specifyRelationFields.hide()
			@

		handleInvalid: (event, validator) =>
			@showStatus 'warning', $.validator.format i18n.invalidFieldsWarning, validator.numberOfInvalids()

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
			contribution.save(form).then(@handleSuccess, @handleError)
			@$('fieldset').prop 'disabled', true
			@showStatus 'info', i18n.uploadInProgressMsg

		handleSuccess: (data, statusText, jqXHR) =>
			@showStatus 'success', i18n.uploadSuccessMsg

		handleError: (jqXHR, statusText, thrownError) =>
			@$('fieldset').prop 'disabled', false
			if jqXHR.status == 400 and jqXHR.responseJSON?
				wrong = _.mapValues jqXHR.responseJSON, _.partial _.join, _, ' '
				@showStatus 'warning', $.validator.format i18n.serverRejectMsg, (wrong.non_field_errors ? '')
				@validator.showErrors wrong
			else
				@showStatus 'danger', i18n.serverErrorMsg

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

		isFirstGeneration: =>
			$(generationFieldValueSelector).val() == 'a'

		uploaderIsNotRecordee: -> 
			$(uploaderRelationFieldValueSelector).val() == 'b'

		toggleFirstGenFields: (event) ->
			if @isFirstGeneration() # Born in Italy
				@firstGenFields.show()
			else
				@firstGenFields.hide()

		toggleSpecifyRelationField: (event) ->
			if @uploaderIsNotRecordee()
				@specifyRelationFields.show()
			else
				@specifyRelationFields.hide()

