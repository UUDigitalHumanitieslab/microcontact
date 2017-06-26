define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ContributionListView extends bb.View
	
		tagName: 'div'
		template: JST['contributionList']
		
		render: (city, dialect) ->
			@$el.html @template {city, dialect}
			@
