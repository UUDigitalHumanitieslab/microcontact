###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'json!api/age-categories'
], (bb, apiAges) ->
	'use strict'
	
	ageCategories = new bb.Collection
	ageCategories.url = 'api/age-categories/'
	ageCategories.comparator = 'least'  # keep sorted by low end of age range
	ageCategories.reset apiAges
	# singleton instance that is fetched once
	
	ageCategories
