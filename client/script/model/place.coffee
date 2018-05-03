###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'model/contribution'
], (bb, _, Contribution) ->
	'use strict'

	class PlaceModel extends bb.Model
		idAttribute: 'placeID'

		setRecordings: (attributes = {}, options) ->
			@recordings.set attributes.recordings, options
			_.omit attributes, 'recordings'

		constructor: (attributes, options) ->
			@recordings = new bb.Collection null, model: Contribution
			attributes = @setRecordings attributes
			super attributes, options

		set: (attributes, options) ->
			attributes = @setRecordings attributes
			super attributes, options
