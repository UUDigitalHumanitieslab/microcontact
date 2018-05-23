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
	'view/informationForm'
	'view/home'
	'view/enter'
	'util/countries'
], (bb, $, Map, Menu, Contributions, Participate, InfoForm, Home, Enter, countries) ->
	'use strict'
	
	class MainRouter extends bb.Router
		initialize: ->
			@map = new Map
			@menu = new Menu el: $ 'nav#nav-main'
			@menu.listenTo @, 'route', @menu.update
			@state = new bb.Model
			@state.on 'change:mode', (state, newMode) =>
				switch state.previous 'mode'
					when 'home' then @home.remove()
					when 'enter' then @enter.remove()
					when 'participate' then @participateView.remove()
					when 'contributions' then @contributionsView.remove()
				switch newMode
					when 'home' then @getHome().render()
					when 'enter' then @getEnter().render()
					when 'participate' then @lazyGetParticipate().render()
					when 'contributions' then @lazyGetContributions().render()

		routes:
			'(home)': 'home'
			'enter': 'enter'
			'participate(/:country)(/:query)': 'participate'
			'contributions': 'contributions'
			'participant-information': 'participantInformation'

		home: ->
			@state.set mode: 'home'
			@navigate 'home'

		enter: ->
			@state.set mode: 'enter'
		
		participate: (country, query) ->
			@state.set mode: 'participate'
			countryLong = (countries.find code: country)?.get 'name'
			result = @lazyGetParticipate().state.get 'result'
			result = undefined unless query? and result?.name == query
			@participateView.state.set {country, countryLong, query, result}

		contributions: ->
			@state.set mode: 'contributions'

		participantInformation: ->
			@infoForm = new InfoForm el: $ 'main'
			@infoForm.render()

		getHome: ->
			@home = new Home
			@home

		getEnter: ->
			# return @enter if @enter?
			@map.render()
			@enter = new Enter map: @map.map
			@enter

		lazyGetParticipate: ->
			return @participateView if @participateView?
			@map.render()
			@participateView = new Participate map: @map.map
			@participateView.state.on 'change', (state) =>
				{country, query} = state.attributes
				switch
					# trigger: true to ensure that the route event is triggered
					when query then @navigate "participate/#{country}/#{query}", trigger: true
					when country
						@participateView.close()
						@navigate "participate/#{country}", trigger: true
					else
						@participateView.close()
						@navigate 'participate'
			@participateView

		lazyGetContributions: ->
			return @contributionsView if @contributionsView?
			@map.render()
			@contributionsView = new Contributions map: @map.map
			@contributionsView
