###
	(c) 2018 Digital Humanities Lab, Utrecht University
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
		id: 'home'
		
		initialize: ->
			@welcome = new Welcome

		render: ->
			return @ if @rendered
			@$el.html @template {}
			@$el.prepend(@welcome.render().el)
			@rendered = true
			@