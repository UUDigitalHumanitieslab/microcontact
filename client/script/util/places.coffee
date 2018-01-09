###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'model/place'
	'json!api/places'
], (bb, Place, apiPlaces) ->
	'use strict'
	
	places = new bb.Collection
	places.url = 'api/places/'
	places.model = Place
	places.reset apiPlaces
	# singleton instance that is fetched once is sufficient
	
	places
