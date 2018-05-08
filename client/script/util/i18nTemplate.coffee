###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'handlebars.runtime'  # instead of 'handlebars' to avoid circular dependency
	'underscore'
	'i18n!nls/text'
], (hbsRuntime, _, specs) ->
	Handlebars = hbsRuntime.default
	_.mapValues specs, Handlebars.template.bind Handlebars
