###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

define [
	'backbone'
	'jquery'
	'view/map'
	'view/menu'
	'view/contributions'
	'view/participate'
	'util/countries'
], (bb, $, Map, Menu, Contributions, Participate, countries) ->
	'use strict'
	
	class MainRouter extends bb.Router
		initialize: ->
			@map = new Map
			@map.render()
			@participate = new Participate map: @map.map
			@contributions = new Contributions map: @map.map
			@menu = new Menu el: $ 'nav#nav-main'
			@menu.listenTo @, 'route', @menu.update
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
					# trigger: true to ensure that the route event is triggered
					when query then @navigate "participate/#{country}/#{query}", trigger: true
					when country then @navigate "participate/#{country}"
					else @navigate 'participate'

		routes:
			'(participate)(/:country)(/:query)': 'participate'
			'contributions': 'contributions'

		participate: (country, query) ->
			@state.set mode: 'participate'
			countryLong = (countries.find code: country)?.get 'name'
			@participate.state.set {country, countryLong, query}

		contributions: ->
			@state.set mode: 'contributions'
			@navigate 'contributions'
