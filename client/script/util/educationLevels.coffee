###
	(c) 2018 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing
###

define [
	'backbone'
	'util/i18nText'
], (bb, i18n) ->
	'use strict'
	
	levels = new bb.Collection [
		{ id: 'e', name: i18n.educationFieldElementary }
		{ id: 'm', name: i18n.educationFieldMiddle }
		{ id: 'h', name: i18n.educationFieldHigh }
		{ id: 'u', name: i18n.educationFieldUniversity }
	]

	levels