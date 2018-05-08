###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'util/i18nText'
	'json!api/countries'
], (bb, _, i18n, apiCountries) ->
	'use strict'

	# localize the country names first
	locale = i18n.currentLanguage
	_.forEach apiCountries, (country) -> country.name = country[locale]

	countries = new bb.Collection
	countries.url = 'api/countries/'
	countries.comparator = 'name'  # keep sorted by country name
	countries.reset apiCountries
	# singleton instance that is fetched once is sufficient

	countries
