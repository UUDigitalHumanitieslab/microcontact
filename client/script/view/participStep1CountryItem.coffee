###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
], (bb, JST) ->
	'use strict'
	
	class ParticipStep1ItemView extends bb.View
		tagName: 'a'
		className: 'list-group-item'
		
		initialize: (options) ->
			@parent = options.parent
		
		attributes: ->
			href: "\#participate/#{@model.get 'code'}"
		
		render: ->
			@$el.text @model.get 'name'
			@
		
		select: ->
			@parent.trigger 'select', @model
		
		events:
			'click': 'select'
