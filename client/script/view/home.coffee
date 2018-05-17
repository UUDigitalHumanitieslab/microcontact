###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Alex Hebing
###

define [
	'backbone'
	'jquery'
	'view/welcome'
	'templates'
], (bb, $, Welcome, JST) ->
	'use strict'
	
	class HomeView extends bb.View
		template: JST['home']
		el: 'main'
		id: 'home'
		
		initialize: ->
			@welcome = new Welcome

		render: ->
			return @ if @rendered
			@$el.html @template {}
			@$el.find('#home').prepend(@welcome.render().el)
			@rendered = true
			@