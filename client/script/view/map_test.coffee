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
			@map = new MapView
		
		it 'renders a map', ->
			spyOn(gmaps, 'Map').and.callThrough()
			@map.render()
			expect(gmaps.Map).toHaveBeenCalled()
