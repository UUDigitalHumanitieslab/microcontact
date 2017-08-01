###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Sheean Spoel
###

define [
	'jquery'
	'collection/googlePlaces'
	'googlemaps'
], ($, GooglePlaces, gmaps) ->
	'use strict'
	
	describe 'GooglePlaces', ->
		beforeEach ->
			gmaps.resetMockState()
			@places = new GooglePlaces(null, new gmaps.Map)

		it 'fetches', ->
			@places.fetch({
				method: 'radarSearch',
				request: null
			})
			
			expect(gmaps.mock.isConstructed).toBeTruthy('The PlacesService should have been constructed.')
			expect(gmaps.mock.requested.indexOf('radarSearch')).toBeGreaterThan(-1, 'The search should have been requested.')

