define [
	'jquery'
	'underscore'
	'util/i18nText'
	'jquery.validate'
], ($, _, i18n) ->
	'use strict'

	# This module localizes jQuery.validate

	$.extend $.validator.messages, {
		required: i18n.fieldRequiredWarning
		remote: i18n.fixFieldWarning
		email: i18n.invalidEmailWarning
		url: i18n.invalidUrlWarning
		date: i18n.invalidDateWarning
		dateISO: i1n.invalidDateWarning # as if people would be helped by saying "ISO"
		number: i18n.invalidNumberWarning
		digits: i18n.invalidDigitsWarning
		equalTo: i18n.invalidEqualToWarning
		extension: i18n.invalidExtensionWarning
		maxlength: $.validator.format(i18n.tooLongWarning)
		minlength: $.validator.format(i18n.tooShortWarning)
		rangelength: $.validator.format(i18n.invalidLengthWarning)
		range: $.validator.format(i18n.invalidValueRangeWarning)
		max: $.validator.format(i18n.tooHighWarning)
		min: $.validator.format(i18n.tooLowWarning)
	}
