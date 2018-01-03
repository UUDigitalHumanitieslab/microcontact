###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'json!api/dialects'
], (bb, apiDialects) ->
	'use strict'
	
	dialects = new bb.Collection
	dialects.url = 'api/dialects'
	dialects.comparator = 'id'  # keep sorted by numerical id
	dialects.reset apiDialects
	# singleton instance that is fetched once is sufficient
	
	dialects
