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
			@$list = $ '<div class=list-group>'
			@$list.append item.render().el for item in @items
			
		
		render: ->
			@$('#particip-step-content').html @$list
			@$('#particip-step-title').text '1. Choose your country'
			@
