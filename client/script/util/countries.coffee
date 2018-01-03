###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'json!api/countries'
], (bb, apiCountries) ->
	'use strict'
	
	countries = new bb.Collection
	countries.url = 'api/countries/'
	countries.comparator = 'name'  # keep sorted by country name
	countries.reset apiCountries
	# singleton instance that is fetched once is sufficient
	
	countries
