define [
	'backbone'
	'underscore'
	'plyr'
	'templates'
	'util/dialects'
	'bootstrap/collapse'
], (bb, _, plyr, JST, dialects) ->
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
			
			@cleanup()
			@players = plyr.setup @$('audio').get(),
				displayDuration: false
			@

		remove: ->
			@cleanup()
			super()

		cleanup: ->
			if @players?
				_.forEach @players, (player) -> player.destroy()
