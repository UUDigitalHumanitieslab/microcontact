###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb) ->
	'use strict'
	
	countries = new bb.Collection
	countries.url = '/api/countries/'
	countries.comparator = 'name'  # keep sorted by country name
	countries.fetch()  # singleton instance that is fetched once is sufficient
	
	countries
