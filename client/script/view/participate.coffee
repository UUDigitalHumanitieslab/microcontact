###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'underscore'
	'googlemaps'
	'collection/googlePlaces'
	'view/participWelcome'
	'view/participGuide'
	'view/participStep1Country'
	'view/participStep2Search'
	'view/participStep3Choose'
	'view/uploadForm'
], (
	bb,
	_,
	gmaps,
	Places,
	Welcome,
	Guide,
	Step1Country,
	Step2Search,
	Step3Choose,
	UploadForm
) ->
	'use strict'
	
	class ParticipateView extends bb.View
		welcomePos: gmaps.ControlPosition.TOP_RIGHT
		guidePos: gmaps.ControlPosition.TOP_CENTER

		initialize: (options) ->
			@map = options.map
			@popup = new gmaps.InfoWindow()
			@places = new Places null, map: @map
			@state = new bb.Model country: false, query: false
			@welcome = new Welcome
			@guide = new Guide
			@step1 = new Step1Country el: @guide.el
			@step2 = new Step2Search el: @guide.el, model: @state
			@step3 = new Step3Choose el: @guide.el, model: @state
			@uploadForm = new UploadForm
			@places.on 'reset update', @resetPins
			@places.on 'error', (places, error) => @step2.renderError error
			@state.on 'change', @updateStep

		render:  ->
			@addControl @welcome, @welcomePos, 1
			@addControl @guide, @guidePos, 1
			@

		addControl: (view, position, index) ->
			div = view.render().el
			div.index = index
			@map.controls[position].push div

		remove: ->
			@popup.close()
			@state.clear()
			@map.controls[@guidePos].pop()
			@map.controls[@welcomePos].pop()
			@

		resetPins: (places) =>
			if @pins
				pin.setMap undefined for pin in @pins
				delete @pins
			@pins = places.map @addPin

		addPin: (place) =>
			pin = new gmaps.Marker
				position: place.get('geometry').location
				title: place.get 'name'
				map: @map
			pin.addListener 'click', @handleClick place
			pin

		handleClick: (place) -> (event) =>
			@popup.close()
			@popup.setPosition event.latLng
			finish = =>
				@popup.setContent @uploadForm.render(place).el
				@popup.open @map
			if place.has 'address_components'
				finish()
			else
				@listenToOnce place, 'change', finish
				place.fetch()
		
		updateStep: (state) =>
			switch
				when state.has 'query' then @places.fetch
					method: 'textSearch'
					query:
						query: state.get 'query'
						types: ['locality']
						bounds: @map.getBounds()
					reset: true
					callback:
						'OK': => @step3.render()
						'ZERO_RESULTS': => @step2.renderMiss()
				when state.has 'country' then @step2.render()
				else @step1.render()

