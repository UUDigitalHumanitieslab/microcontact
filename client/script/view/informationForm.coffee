###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'backbone'
	'templates'
], (bb, JST) ->
	'use strict'
	
	class InformationFormView extends bb.View
		template: JST['informationForm']
		className: 'container'
		render: -> @$el.html @template {}
