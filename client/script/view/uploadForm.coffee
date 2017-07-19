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
			'click #user-consent': 'activate'
			'submit form': 'submit'
		
		render: (place) ->
			@$el.html @template {place: place.toInternal(), dialects}
			@
		
		submit: (event) ->
			event.preventDefault()
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

		activate: ->
			if @$('#user-consent').prop('checked')
				@$('#submit-button').prop('disabled', false)
			else
				@$('#submit-button').prop('disabled', true)
