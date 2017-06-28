# add properties missing from the mock google maps bower component
define [
	'google-maps-mock'
], (gmaps) ->	
	gmaps.resetMockState = () ->
		# represents the changes which might have been done on the mock maps object
		gmaps.mock = 
			isConstructed: false
			requested: []

	gmaps.resetMockState()

	gmaps.ControlPosition =
		TOP_CENTER: 0
		TOP_LEFT: 1
		TOP_RIGHT: 2
		LEFT_TOP: 3
		RIGHT_TOP: 4
		LEFT_CENTER: 5
		RIGHT_CENTER: 6
		LEFT_BOTTOM: 7
		RIGHT_BOTTOM: 8
		BOTTOM_CENTER: 9
		BOTTOM_LEFT: 10
		BOTTOM_RIGHT: 11
	gmaps.Map = () ->
		controls: ([] for i in Object.keys(gmaps.ControlPosition))

	# mock the places library
	gmaps.places = PlacesService: class PlacesService				
		constructor: (map) -> 
			gmaps.mock.isConstructed = true
			gmaps.mock.requested = []

		nearbySearch: (request, callback) -> gmaps.mock.requested.push('nearBySearch')
		textSearch: (request, callback) -> gmaps.mock.requested.push('textSearch')
		radarSearch: (request, callback) -> gmaps.mock.requested.push('radarSearch')

	gmaps
