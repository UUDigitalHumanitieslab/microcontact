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
				when 'home'
					@model.set {show:true, showEnter:false, showParticipate: false, showContributions:false}
					@render()
					@makeLastChildActive()
				when 'enter'
					@model.set {show:true, showEnter:true, showParticipate: false, showContributions:false}
					@render()
					@makeLastChildActive()
				when 'participate'
					[country, query] = params
					@model.set {country, show: true, query, showParticipate: true, showEnter:true, showContributions:false}
					@render()
					@makeLastChildActive()
				when 'contributions'
					@model.set {show:true, showEnter:true, showParticipate: false, showContributions:true}
					# @model.set {show: false}
					@render()
			@$("\#tab-#{route}").addClass 'active'

		makeLastChildActive: ->
			@$('\#tab-participate li').last().addClass 'active'
