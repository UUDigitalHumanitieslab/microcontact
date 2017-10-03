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
			@$('form').validate
				submitHandler: @submit
				# invalidHandler: (event, validator) -> null
				rules:
					email:
						require_from_group: [1, '.upload-contact']
					phone:
						require_from_group: [1, '.upload-contact']
				errorClass: 'has-error'
				validClass: 'has-success'
				highlight: (element, error, valid) ->
					$(element).parent().removeClass(valid).addClass(error)
					$(element).siblings('.glyphicon').removeClass(
						'glyphicon-ok'
					).addClass(
						'glyphicon-remove'
					).parent().addClass 'has-feedback'
				unhighlight: (element, error, valid) ->
					$(element).parent().removeClass(error).addClass(valid)
					$(element).siblings('.glyphicon').removeClass(
						'glyphicon-remove'
					).addClass('glyphicon-ok').parent().addClass 'has-feedback'
				errorPlacement: (errorLabel, element) ->
					$(errorLabel).addClass('help-block').appendTo(
						$(element).parent()
					)
			@
		
		submit: (form, event) =>
			event.preventDefault()
			return unless @consentGiven
			@$('#upload-status').text 'Uploading, please wait...'
			contribution = new Contribution
			@updateLanguages =>
				contribution.save(form).done => @$('#upload-status').text 'Grazie!'
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

		updateConsent: ->
			@consentGiven = @$('#user-consent').prop('checked')
			@$('#submit-button').prop('disabled', !@consentGiven)
