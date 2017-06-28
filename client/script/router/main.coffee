###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'jquery'
	'view/map'
	'view/contributions'
	'view/participate'
	'bootstrap/tab'
], (bb, $, Map, Contributions, Participate) ->
	'use strict'
	
	class MainRouter extends bb.Router
		initialize: ->
			@map = new Map
			@map.render()
			@participate = new Participate map: @map.map
			@contributions = new Contributions map: @map.map
			@state = new bb.Model
			@state.on 'change:mode', (state, newMode) =>
				switch state.previous 'mode'
					when 'participate' then @participate.remove()
					when 'contributions' then @contributions.remove()
				switch newMode
					when 'participate' then @participate.render()
					when 'contributions' then @contributions.render()
			@participate.state.on 'change', (state) =>
				{country, query} = state.attributes
				switch
					when query then @navigate "participate/#{country}/#{query}"
					when country then @navigate "participate/#{country}"
					else @navigate 'participate'

		routes:
			'(participate)(/:country)(/:query)': 'participate'
			'contributions': 'contributions'

		participate: (country, query) ->
			@state.set mode: 'participate'
			$('nav a[href="#participate"]').tab 'show'
			@participate.state.set {country, query}

		contributions: ->
			@state.set mode: 'contributions'
			$('nav a[href="#contributions"]').tab 'show'
			@navigate 'contributions'
