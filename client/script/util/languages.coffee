###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb) ->
	'use strict'
	
	languages = new bb.Collection
	languages.url = '/api/languages/'
	languages.comparator = 'language'  # keep sorted by language name
	languages.fetch()  # singleton instance that is fetched once is sufficient
	
	languages
