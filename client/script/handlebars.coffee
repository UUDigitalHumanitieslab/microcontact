###
	(c) 2016 Julian Gonggrijp
###

define [
	'handlebars.runtime'
	'util/i18nTemplate'
], (hbsRuntime, partialTemplates) ->
	Handlebars = hbsRuntime.default
	Handlebars.registerPartial partialTemplates
	Handlebars
