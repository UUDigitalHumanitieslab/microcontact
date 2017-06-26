###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb) ->
	'use strict'
	
	class GooglePlaceModel extends bb.Model
		idAttribute: 'place_id'
