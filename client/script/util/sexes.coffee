###
	(c) 2018 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing
###

define [
	'backbone'
	'util/i18nText'
], (bb, i18n) ->
	'use strict'
	
	sexes = new bb.Collection [
		{ id: 'a', name: i18n.sexFieldMale }
		{ id: 'b', name: i18n.sexFieldFemale }
		{ id: 'c', name: i18n.sexFieldOther }
	]

	sexes