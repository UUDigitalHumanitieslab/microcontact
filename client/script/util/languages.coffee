###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'json!/api/languages/'
], (bb, apiLanguages) ->
	'use strict'
	
	languages = new bb.Collection
	languages.url = '/api/languages/'
	languages.comparator = 'language'  # keep sorted by language name
	languages.reset apiLanguages
	# singleton instance that is fetched once is sufficient
	
	languages
