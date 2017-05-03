###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'model/googlePlace'
], (bb, _, gmaps, GooglePlace) ->
	'use strict'
	
	class GooglePlacesCollection extends bb.Collection
		model: GooglePlace
		
		# should be passed a gmaps.map
		initialize: (content, options) ->
			@service = new gmaps.places.PlacesService options.map
		
		# Uses Google Maps fetching instead of jQuery fetching. Updates
		# this with the results. Options:
		#     method: one of 'nearbySearch', 'textSearch', 'radarSearch'
		#     query: the query object to be passed to the PlacesService
		#     callback: optional, either
		#       - a function: takes parameters (results, status)
		#       - an object: maps gmaps.places.PlacesServiceStatus keys to
		#                    functions that take zero or one arguments.
		#                    'default' is allowed as wildcard.
		#     reset, add, remove, merge: as in bb.Collection.fetch
		fetch: (options) ->
			@service[options.method] options.request, @callback options
			@trigger 'request', @, null, options
			return
		
		# Returns a bound callback function that is passed to the
		# PlacesService as the second argument in a search request.
		callback: (options) =>
			handleData = if options.reset
				_.bind @reset, @
			else
				setOptions = _.pick options, ['add', 'remove', 'merge']
				_.bind @set, @, _, setOptions
			clientCallback = switch
				when _.isFunction options.callback
					options.callback
				when _.isPlainObject options.callback
					cb = options.callback
					(results, status) ->
						(cb[status] or cb.default or _.noop) results
				else
					_.noop
			(results, status) =>
				clientCallback results, status
				switch status
					when 'OK' then handleData results
					when 'ZERO_RESULTS' then handleData []
					else @trigger 'error', @, status, options
