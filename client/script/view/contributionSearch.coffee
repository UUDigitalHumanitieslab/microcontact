###
	(c) 2018 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing, Jelte van Boheemen
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'templates'
], (bb, _, gmaps, JST) ->
	'use strict'

	class ContributionSearchView extends bb.View
		template: JST['contributionSearch']

		render: ->
			@$el.html @template {}
			@
		