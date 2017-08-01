define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class ContributionListView extends bb.View
		className: 'contributions-pin'
		tagName: 'div'
		template: JST['contributionList']
		
		render: (city, pins) ->
			@$el.html @template {city, pins}
			@
