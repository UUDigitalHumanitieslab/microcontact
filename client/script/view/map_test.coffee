###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'jquery'
	'view/map'
	'googlemaps'
], ($, MapView, gmaps) ->
	'use strict'
	
	describe 'MapView', ->
		beforeEach ->
			setFixtures $ '<main>'
			@map = new MapView
		
		it 'renders a map', ->
			spyOn(gmaps, 'Map').and.callThrough()
			@map.render()
			main = $ 'main'
			expect(main.children()).toHaveLength 1
			expect(gmaps.Map).toHaveBeenCalled()
