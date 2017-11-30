###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
], (bb, _) ->
	'use strict'

	class ContributionModel extends bb.Model

		url: 'api/recordings/'

		# Override bb.Model::save to permit forms with file fields
		save: (attributes, options = {}, more) ->
			if attributes instanceof HTMLFormElement
				_.extend options,
					data: new FormData attributes
					cache: false
					contentType: false
				return super null, options
			super attributes, options, more
