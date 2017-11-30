###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'underscore'
	'util/i18nTemplate'
], (_, partials) ->
	strings = {}
	_.forOwn partials, (partial, name) ->
		Object.defineProperty strings, name,
			enumerable: true,
			configurable: true,
			get: ->
				value = partial {}
				Object.defineProperty strings, name, {enumerable: true, value}
				value
	strings
