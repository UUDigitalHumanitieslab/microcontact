###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Sheean Spoel
###

define [
	'jquery'
	'view/map'
	'view/participate'
	'googlemaps'
], ($, MapView, ParticipateView, gmaps) ->
	'use strict'
	
	describe 'ParticipateView', ->
		beforeEach ->
			# the participation view draws inside the map
			setFixtures $ '<main>'
			@map = new MapView
			@map.render()

			@participate = new ParticipateView map: @map.map
		
		it 'renders the participation view', ->
			map = @map.map
			getControlsCount = () -> _.reduce(
				map.controls
				(memo, num) -> memo  + num.length
				0)

			expect(getControlsCount()).toBe(1, 'Only the logo control should be rendered at first')
			@participate.render()
			div = $ 'div[id="participate-guide"]'

			# did we add controls?
			expect(getControlsCount()).toBeGreaterThan(1, 'Controls should be added')
