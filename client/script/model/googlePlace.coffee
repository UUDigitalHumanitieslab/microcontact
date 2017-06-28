###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
], (bb, _, gmaps) ->
	'use strict'
	
	class GooglePlaceModel extends bb.Model
		idAttribute: 'place_id'
		
		initialize: (content, options) ->
			@service = @collection?.service ? (
				new gmaps.places.PlacesService options.map if options.map
			)
		
		# Uses Google Maps fetching instead of jQuery fetching. Updates
		# this with the results. Works only if this was initialized with
		# a map or if it is a member of a collection. Options:
		#     placeId: optional id of the place to request
		#     callback: optional, either
		#       - a function: takes parameters (results, status)
		#       - an object: maps gmaps.places.PlacesServiceStatus keys to
		#                    functions that take zero or one arguments.
		#                    'default' is allowed as wildcard.
		fetch: (options) ->
			@service ?= @collection?.service
			request = placeId: options?.placeId ? @id
			@service.getDetails request, @callback options
			@trigger 'request', @, null, options
			return
		
		# Returns a bound callback function that is passed to the
		# PlacesService as the second argument in a search request.
		callback: (options) =>
			clientCallback = switch
				when _.isFunction options?.callback
					options.callback
				when _.isPlainObject options?.callback
					cb = options.callback
					(results, status) ->
						(cb[status] or cb.default or _.noop) results
				else
					_.noop
			(results, status) =>
				clientCallback results, status
				switch status
					when 'OK' then @set results
					else @trigger 'error', @, status, options
		
