define [
	'backbone'
	'underscore'
	'templates'
], (bb, _, JST) ->
	'use strict'
	
	class UploadFormView extends bb.View
	
		tagName: 'div'
		template: JST['uploadForm']
		
		render: (geocodeResults, geocodeStatus) ->
			delete @match
			data = {}
			switch geocodeStatus
				when 'OK'
					@match = _.find geocodeResults, (r) ->
						'locality' in r.types
					if @match
						country = _.find @match.address_components, (c) ->
							'country' in c.types
						data.country = country.short_name
						data.city = @match.address_components[0].long_name
				else
					console.log "#{status}<br>#{JSON.stringify results}"
			console.log data
			@$el.html @template data
			@
		