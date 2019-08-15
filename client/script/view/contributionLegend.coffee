define [
	'backbone'
	'templates'
	'util/i18nText'
	'bootstrap/popover'
	'util/sanitizeWhitelist'
], (bb, JST, i18n) ->
	'use strict'

	class ContributionLegendView extends bb.View

		tagName: 'a'
		className: 'btn btn-default gmaps-control'
		attributes:
			tabindex: 2
			role: 'button'
			'data-toggle': 'popover'
			'data-trigger': 'focus'
			'data-placement': 'top'
			title: i18n.dialectLegendTitle
		template: JST.contributionLegend

		render: ->
			@$el.text(i18n.dialectLegendButton).popover
				content: @template dialects: @collection.toJSON()
				html: true
			@
