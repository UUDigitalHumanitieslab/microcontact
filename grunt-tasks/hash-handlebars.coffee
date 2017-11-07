###
	(c) 2017 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###


name = 'hash-handlebars'
description = 'Precompile each string in a JS object separately using Handlebars.'


module.exports = (grunt) ->
	'use strict'
	Handlebars = require 'handlebars'

	grunt.registerMultiTask name, description, ->
		options = this.options
			processFile: (text) -> text
		for file in this.files
			content = options.processFile grunt.file.read file.src
			if typeof content == 'string'
				content = JSON.parse content
			grunt.file.write file.dest, JSON.stringify new ->
				for key, value of content
					@[key] = Handlebars.precompile value
				@
