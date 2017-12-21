define [
	'backbone'
	'underscore'
	'templates'
	'util/dialects'
], (bb, _, JST, dialects) ->
	'use strict'
	
	class ContributionListView extends bb.View
		className: 'contributions-pin'
		tagName: 'div'
		template: JST['contributionList']
		
		render: (place) ->
			lists = _.groupBy place.recordings.toJSON(), 'dialect'
			sections = _.map lists, (list, id) ->
				dialect: dialects.get(id).get 'dialect'
				color: dialects.get(id).get 'color'
				recordings: list
			@$el.html @template {city: place.get('name'), sections}
			@
