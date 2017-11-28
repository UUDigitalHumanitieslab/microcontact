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
			hbsOptions: {}
			wrapStart: '{\n'
			wrapEnd: '\n}'
			indent: '    '
			quoteKey: '"'
			keyValueSeparator: ': '
			entrySeparator: ',\n'
		for file in this.files
			content = options.processFile grunt.file.read file.src
			if typeof content == 'string'
				content = JSON.parse content
			entries = for key, value of content
				"#{options.indent}#{options.quoteKey}#{key}#{options.quoteKey}#{
					options.keyValueSeparator
				}#{Handlebars.precompile value, options.hbsOptions}"
			result = [
				options.wrapStart
				entries.join options.entrySeparator
				options.wrapEnd
			].join ''
			grunt.file.write file.dest, result
