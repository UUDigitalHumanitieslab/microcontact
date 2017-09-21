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
], (bb, $, _, JST, Contribution, dialects, languages, ages) ->
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
			contribution = new Contribution
			@updateLanguages =>
				contribution.save(form[0]).done => @$el.text 'Grazie!'

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
