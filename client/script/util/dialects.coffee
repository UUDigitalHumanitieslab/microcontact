###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb) ->
	'use strict'
	
	dialects = new bb.Collection
	dialects.url = '/api/dialects'
	dialects.comparator = 'id'  # keep sorted by numerical id
	dialects.fetch()  # singleton instance that is fetched once is sufficient
	
	dialects
