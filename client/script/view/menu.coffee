###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class MenuView extends bb.View
		template: JST['menu']
		tagName: 'nav'
		
		initialize: ->
			@model = new bb.Model {}
			@render()
		
		render: ->
			@$el.html @template @model.attributes
			@
		
		update: (route, params) ->
			@$('li').removeClass 'active'
			switch route
				when 'participate'
					[country, query] = params
					@model.set {country, show: true, query}
					@render()
					@$('\#tab-participate li').last().addClass 'active'
				when 'contributions'
					@model.set {show: false}
					@render()
			@$("\#tab-#{route}").addClass 'active'
