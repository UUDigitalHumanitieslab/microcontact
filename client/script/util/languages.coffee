###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'util/i18nText'
	'json!api/languages'
], (bb, _, i18n, apiLanguages) ->
	'use strict'

	# localize the country names first
	locale = i18n.currentLanguage
	_.forEach apiLanguages, (language) -> language.language = language[locale]

	languages = new bb.Collection
	languages.url = 'api/languages/'
	languages.comparator = 'language'  # keep sorted by language name
	languages.reset apiLanguages
	# singleton instance that is fetched once is sufficient

	languages

	

