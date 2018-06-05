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
	'bootstrap/popover'
], (bb, _, plyr, JST, dialects, ages, sexes, eduLevels, globalLanguages) ->
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
					originalDatasource: recording.recording_original_datasource
					recording_web: recording.recording_web
					ageCategoryLeast: ages.get(recording.age).get 'least'
					ageCategoryGreatest: ages.get(recording.age).get 'greatest'
					sex: sexes.get(recording.sex).get 'name'
					education: eduLevels.get(recording.education).get 'name'
					origin: `recording.origin == ',' ? undefined : recording.origin`
					migrated: recording.migrated
					languages: _(recording.languages).map((language) ->
						globalLanguages.get(language).get('language')
					).join(', ')

			@$el.html @template { city: place.get('name'), sections }
			@$('[data-toggle="popover"]').popover({ container: 'body' })

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
