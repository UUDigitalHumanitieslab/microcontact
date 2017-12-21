###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp, Sheean Spoel
###

define [
	'backbone'
	'googlemaps'
	'templates'
	'util/dialects'
], (bb, gmaps, JST, dialects) ->
	'use strict'

	iconSize = 24
	iconOpacity = 0.9
	iconLogScale = 1.1

	class ContributionPieView extends bb.View
		template: JST['contributionPie']

		render: ->
			totalCount = @model.recordings.length
			scale = iconSize * (1 + iconLogScale * Math.log(totalCount))
			dialectsHistogram = @model.recordings.countBy 'dialect'

			# convert to list, to make it easily iterable in the template
			x = 1
			y = 0
			
			currentFraction = 0
			updateX = (fraction) ->
				currentFraction += fraction
			
				x = Math.cos(2 * Math.PI * currentFraction)
				y = Math.sin(2 * Math.PI * currentFraction)
				x

			half = totalCount / 2
			getPiePiece = (dialectID) ->
				dialect: dialects.get(dialectID).get 'dialect'
				color: dialects.get(dialectID).get 'color'
				fraction: dialectsHistogram[dialectID]
				startX: x
				startY: y
				largeArcFlag: if dialectsHistogram[dialectID] > 0.5 then 1 else 0
				endX: updateX(dialectsHistogram[dialectID])
				endY: y

			pieces = (getPiePiece(dialect) for dialect of dialectsHistogram)
			
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
