###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp, Sheean Spoel
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'templates'
	'util/dialects'
], (bb, _, gmaps, JST, dialects) ->
	'use strict'

	iconSize = 24
	iconOpacity = 0.9
	iconLogScale = 1.1

	class ContributionPieView extends bb.View
		template: JST['contributionPie']

		render: ->
			totalCount = @model.recordings.length
			dialectsHistogram = @model.recordings.countBy 'dialect'
			# by using _.toPairs below, we guarantee same order in both arrays
			[dialectIDs, counts] = _.unzip _.toPairs dialectsHistogram
			fractions = _.map counts, (count) -> count / totalCount
			cumuFractions = _.reduce fractions, ((accumulator, fraction) ->
				accumulator.push _.last(accumulator) + fraction
				accumulator
			), [0]
			console.assert (_.last(cumuFractions) == 1)
			positions = _.map cumuFractions, (fraction) ->
				circleFraction = 2 * Math.PI * fraction
				{x: Math.cos(circleFraction), y: Math.sin(circleFraction)}

			pieces = _.zipWith dialectIDs, fractions, _.initial(positions), _.tail(positions), (dialectID, fraction, start, end) ->
				dialect: dialects.get(dialectID).get 'dialect'
				color: dialects.get(dialectID).get 'color'
				largeArcFlag: if fraction > 0.5 then 1 else 0
				fraction: fraction
				startX: start.x, startY: start.y
				endX: end.x, endY: end.y

			@size = Math.floor(iconSize * (1 + iconLogScale * Math.log(totalCount)))			
			@$el.html @template {pieces, @size, opacity: iconOpacity}
			@

		# For use as a Google Maps marker
		asIcon: ->
			url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(@$el.html())
			# image is assumed to be 32px wide
			origin: new gmaps.Point(0,0)
			anchor: new gmaps.Point(@size / 2, @size / 2)
			size: new gmaps.Size(@size, @size)
