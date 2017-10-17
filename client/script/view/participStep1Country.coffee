###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'jquery'
	'view/participStep1CountryItem'
	'util/countries'
], (bb, $, Item, countries) ->
	'use strict'
	
	class ParticipStep1View extends bb.View
		className: 'list-group'
		
		initialize: ->
			@items = countries.map (country) => new Item 
				model: country
				parent: @
			@$list = $ '<div class="list-group lead">'
			@$list.append item.render().el for item in @items
			@on 'select', (country) ->
				@model.set
					country: country.get 'code'
					countryLong: country.get 'name'
					query: null
					result: null
		
		render: ->
			@$('#particip-step-content').html @$list
			@$('#particip-step-title').text 'Seleziona il tuo Paese'
			@
