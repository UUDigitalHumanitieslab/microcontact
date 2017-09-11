###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb) ->
	'use strict'
	
	ageCategories = new bb.Collection
	ageCategories.url = '/api/age-categories'
	ageCategories.comparator = 'least'  # keep sorted by low end of age range
	ageCategories.fetch()  # singleton instance that is fetched once
	
	ageCategories
