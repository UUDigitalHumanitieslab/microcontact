###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'util/i18nText'
	'json!api/dialects'
], (bb, _, i18n, apiDialects) ->
	'use strict'

	# localize the dialect names first
	locale = i18n.currentLanguage
	_.forEach apiDialects, (dialect) -> dialect.dialect = dialect[locale]

	dialects = new bb.Collection
	dialects.url = 'api/dialects'
	dialects.comparator = 'id'  # keep sorted by numerical id
	dialects.reset apiDialects
	# singleton instance that is fetched once is sufficient

	dialects
