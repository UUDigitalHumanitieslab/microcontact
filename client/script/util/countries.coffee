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
	localized = _(apiCountries).map('code').map(_.partial _.get, i18n).value()
	_.forEach apiCountries, (country, index) -> country.name = localized[index]

	countries = new bb.Collection
	countries.url = 'api/countries/'
	countries.comparator = 'name'  # keep sorted by country name
	countries.reset apiCountries
	# singleton instance that is fetched once is sufficient

	countries
