###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'jquery'
	'underscore'
	'util/i18nText'
	'jquery.validate'
], ($, _, i18n) ->
	'use strict'
	
	# This module adds two methods to jQuery.validate: minFileSize, maxFileSize.
	# In addition, it exports the `asBytes` function.
	
	sizePattern = /(\d+) *([kMG]B|bytes)?/i
	baseSize =
		bytes: 1
		kb: 1024
		mb: 1024 * 1024
		gb: 1024 * 1024 * 1024
	
	# Convert strings such as '10 MB' to a number in bytes (10e6 in this case).
	# See table above for available units; they are case-insensitive.
	# If `limit` is already a number, return it unchanged.
	# This function is exported from the module.
	asBytes = (limit) ->
		unless _.isNumber limit
			[fullMatch, factor, unit] = _.toString(limit).match sizePattern
			limit = (_.toNumber factor) * baseSize[_.toLower unit]
		limit
	
	getSize = (element) -> element.files?[0]?.size
	
	# Specify the limit either as a string with an SI unit (e.g. '10 MB')
	# or as a plain number in bytes. It is recommended to use a string
	# with a unit, as this will be shown to the user in an error message.
	$.validator.addMethod 'minFileSize', (
		(value, element, param) ->
			return true if this.optional element
			size = getSize element
			return true unless size?
			minimum = asBytes param
			size >= minimum
	), $.validator.format i18n.minFileSizeMsg
	
	# See minFileSize for documentation.
	$.validator.addMethod 'maxFileSize', (
		(value, element, param) ->
			return true if this.optional element
			size = getSize element
			return true unless size?
			maximum = asBytes param
			size <= maximum
	), $.validator.format i18n.maxFileSizeMsg
	
	asBytes
