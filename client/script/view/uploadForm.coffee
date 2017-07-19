define [
	'backbone'
	'underscore'
	'templates'
	'util/dialects'
], (bb, _, JST, dialects) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		template: JST['uploadForm']
		
		render: (place) ->
			@$el.html @template {place: place.toInternal(), dialects}
			@
		