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
		# used to validate the state of the mock PlacesService
		constructed = false
		requested = []

		beforeEach ->
			constructed = false
			requested = []

			# mock the places library
			gmaps.places = PlacesService: class PlacesService				
				constructor: (map) -> 
					constructed = true
					requested = []

				nearbySearch: (request, callback) -> requested.push('nearBySearch')
				textSearch: (request, callback) -> requested.push('textSearch')
				radarSearch: (request, callback) -> requested.push('radarSearch')

			@places = new GooglePlaces(null, new gmaps.Map)

		it 'fetches', ->
			@places.fetch({
				method: 'radarSearch',
				request: null
			})
			
			expect(constructed).toBeTruthy('The PlacesService should have been constructed.')
			expect(requested.indexOf('radarSearch')).toBeGreaterThan(-1, 'The search should have been requested.')

