###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'googlemaps'
], (bb, gmaps) ->
	'use strict'
	
	class ParticipateView extends bb.View
		null