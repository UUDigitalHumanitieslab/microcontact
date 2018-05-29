define [
	'backbone'
	'underscore'
	'plyr'
	'templates'
	'util/dialects'
	'util/ageCategories'
	'util/sexes'
	'util/educationLevels'
	'util/languages'
	'bootstrap/collapse'
], (bb, _, plyr, JST, dialects, ages, sexes, eduLevels, languagesAPI) ->
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
				recordings: _.map list, (recording) ->
					id: recording.id
					ageCategoryLeast: ages.get(recording.age).get 'least'
					ageCategoryGreatest: ages.get(recording.age).get 'greatest'
					sex: sexes.get(recording.sex).get 'name'
					education: eduLevels.get(recording.education).get 'name'
					origin: `recording.origin == ',' ? undefined : recording.origin`
					migrated: recording.migrated
					languages: _(recording.languages).map((language) ->
						languagesAPI.get(language).get('language')
					).join(', ')
					
			@$el.html @template {city: place.get('name'), sections}
			
			@cleanup()
			@players = plyr.setup @$('audio').get(),
				displayDuration: false
			@

		mapRecordings: (recordings) ->
			mappedRecordings = _.map recordings, (recording, id) ->
				ageCategory: ages.get(id)
			mappedRecordings

		remove: ->
			@cleanup()
			super()

		cleanup: ->
			if @players?
				_.forEach @players, (player) -> player.destroy()
