###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

'use strict'

module.exports = (grunt) ->
	stripRegExp = (path, ext) -> new RegExp "^#{path}/|\\.#{ext}$", 'g'
	httpProxy = require 'http-proxy'
	proxy = httpProxy.createProxyServer {}
	fs = require 'fs'
	googleMapsAPIKey = fs.readFileSync('.gmapikey').toString().trim()
	process = require 'process'
	extendEnv = (modifications) -> Object.assign {}, process.env, modifications

	grunt.initConfig
		source: 'client'
		script: 'script'
		style: 'style'
		template: 'template'
		templateSrc: '<%= source %>/<%= template %>'
		i18n: 'nls'
		image: 'image'
		functional: 'functional-tests'
		stage: '.tmp'
		dist: 'dist'
		venv: process.env.VIRTUAL_ENV

		clean:
			develop: ['<%= stage %>/index.html']
			dist: ['<%= dist %>/index.html']
			all: [
				'<%= stage %>'
				'<%= dist %>'
				'.<%= functional %>'
				'.*cache'
				'**/__pycache__'
				'**/*.{pyc,pyo}'
			]

		handlebars:
			options:
				amd: true
				processName: (path) ->
					src = grunt.config('templateSrc')
					pattern = stripRegExp src, 'mustache'
					path.replace pattern, ''
				compilerOptions:
					knownHelpers: {}
					knownHelpersOnly: true
					compat: true
			compile:
				src: [
					'<%= source %>/<%= template %>/**/*.mustache'
					'!<%= source %>/<%= template %>/index.mustache'
				]
				dest: '<%= stage %>/<%= script %>/templates.js'

		coffee:
			options:
				bare: true
			compile:
				files: [{
					expand: true
					cwd: '<%= source %>/<%= script %>'
					src: ['**/*.coffee']
					dest: '<%= stage %>/<%= script %>/'
					ext: '.js'
				}, {
					expand: true
					cwd: '<%= source %>/<%= i18n %>'
					src: ['!root/*.coffee', '**/*.coffee']
					dest: '<%= stage %>/<%= i18n %>/'
					ext: '.js.pre'
				}, {
					expand: true
					cwd: '<%= source %>/<%= i18n %>'
					src: ['root/*.coffee']
					dest: '<%= stage %>/<%= i18n %>/'
					ext: '.js'
				}]
			functional:
				expand: true
				cwd: '<%= functional %>'
				src: ['**/*.coffee']
				dest: '.<%= functional %>/'
				ext: '.js'

		'hash-handlebars':
			compile:
				expand: true
				cwd: '<%= stage %>/<%= i18n %>'
				src: ['**/*.js.pre']
				dest: '<%= stage %>/<%= i18n %>'
				ext: '.js'
				options:
					processFile: eval  # JS object literal, *not* JSON
					wrapStart: 'define({\n'
					wrapEnd: '\n});'
					hbsOptions: '<%= handlebars.options.compilerOptions %>'

		'compile-handlebars':
			develop:
				src: '<%= source %>/<%= template %>/index.mustache'
				dest: '<%= stage %>/index.html'
				partials: '<%= stage %>/<%= script %>/*.js'
				templateData:
					production: false
					gmapikey: googleMapsAPIKey
			dist:
				src: '<%= source %>/<%= template %>/index.mustache'
				dest: '<%= dist %>/index.html'
				partials: '<%= stage %>/<%= script %>/*.js'
				templateData:
					production: true
					gmapikey: googleMapsAPIKey

		sass:
			compile:
				options:
					includePaths: [
						'bower_components/bootstrap-sass/assets/stylesheets'
					]
					sourceComments: true
				expand: true
				cwd: '<%= source %>/<%= style %>'
				src: ['*.sass', '*.scss']
				dest: '<%= stage %>/<%= style %>'
				ext: '.css.pre'

		postcss:
			compile:
				options:
					processors: [
						(require 'autoprefixer') {
							browsers: [
								'Android 2.3'
								'Android >= 4'
								'Chrome >= 20'
								'Firefox >= 24'
								'Explorer >= 8'
								'iOS >= 6'
								'Opera >= 12'
								'Safari >= 6'
							]
						}
					]
				expand: true
				cwd: '<%= stage %>/<%= style %>'
				src: ['*.css.pre']
				dest: '<%= stage %>/<%= style %>'
				ext: '.css'

		symlink:
			base:
				src: ['bower_components']
				dest: '<%= stage %>/bower_components'
			develop:
				src: ['<%= source %>/<%= image %>']
				dest: '<%= stage %>/<%= image %>'
			dist:
				src: ['<%= source %>/<%= image %>']
				dest: '<%= dist %>/<%= image %>'

		shell:
			backend:
				options:
					execOptions:
						env: extendEnv
							PYTHONUNBUFFERED: 1  # enables console output
				command: ()=>
					if process.platform == "win32"
						return "<%= venv %>/Scripts/python manage.py runserver"
					else
						return "<%= venv %>/bin/python manage.py runserver"
						#
			pytest:
				files: [{
					src: [
						'microcontact/**/*_test.py'
						'recordings/**/*_test.py'
					]
				}]
				command: ->
					files = (o.src for o in grunt.config 'shell.pytest.files')
					src = [].concat.apply([], files)
					paths = (grunt.file.expand src).join ' '
					"py.test #{paths}"


		jasmine:
			test:
				options:
					specs: '<%= stage %>/<%= script %>/**/*_test.js'
					helpers: [
						'bower_components/jquery/dist/jquery.js'
						'bower_components/jasmine-jquery/lib/jasmine-jquery.js'
					]
# host: 'http://localhost:8000/'
					template: require 'grunt-template-jasmine-requirejs'
					templateOptions:
						requireConfigFile: '<%= stage %>/<%= script %>/developConfig.js'
						requireConfig:
							baseUrl: '<%= script %>'
							paths:
								'google-maps-mock': '../bower_components/google-maps-mock/google-maps-mock'
								googlemaps: 'mock/google-maps'
							shim:
								'google-maps-mock':
									deps: []
									exports: 'google.maps'
					outfile: '<%= stage %>/_SpecRunner.html'
					display: 'full'
					summary: true

		casperjs:
			options:
				silent: true
			functional:
				src: ['.<%= functional %>/**/*.js']

		watch:
			handlebars:
				files: '<%= handlebars.compile.src %>'
				tasks: 'handlebars:compile'
			scripts:
				files: '<%= coffee.compile.src %>'
				options:
					cwd:
						files: '<%= coffee.compile.cwd %>'
				tasks: ['newer:coffee:compile', 'jasmine:test']
			sass:
				files: '<%= sass.compile.src %>'
				options:
					cwd:
						files: '<%= sass.compile.cwd %>'
				tasks: ['sass:compile', 'postcss:compile']
			html:
				files: [
					'<%= grunt.config("compile-handlebars.develop.src") %>'
					'<%= stage %>/<%= script %>/developConfig.js'
				]
				tasks: ['clean:develop', 'compile-handlebars:develop']
			python:
				files: ['microcontact/**/*.py', 'recordings/**/*.py']
				tasks: 'newer:shell:pytest'
			functional:
				files: '<%= coffee.functional.src %>'
				options:
					cwd:
						files: '<%= coffee.functional.cwd %>'
				tasks: ['newer:coffee:functional', 'newer:casperjs:functional']
			config:
				files: 'Gruntfile.coffee'
			livereload:
				files: [
					'<%= script %>/**/*.js'
					'<%= style %>/*.css'
					'<%= image %>/*'
					'*.html'
					'!_SpecRunner.html'
				]
				options:
					cwd:
						files: '<%= stage %>'
					livereload: true

		requirejs:
			dist:
				options:
					baseUrl: '<%= stage %>/<%= script %>'
					mainConfigFile: '<%= stage %>/<%= script %>/developConfig.js'
					wrapShim: true
					inlineJSON: false
					paths:
						jquery: 'empty:'
						backbone: 'empty:'
						underscore: 'empty:'
						'handlebars.runtime': 'empty:'
						async: 'empty:'
						googlemaps: 'empty:'
						select2: 'empty:'
						'jquery.validate': 'empty:'
						'jquery.validate.additions': 'empty:'
					include: ['main.js']
					out: '<%= dist %>/microcontact.js'

		cssmin:
			dist:
				src: ['<%= stage %>/<%= style %>/*.css']
				dest: '<%= dist %>/microcontact.css'

		concurrent:
			preserver:
				tasks: ['shell:pytest', 'compile']
			develop:
				tasks: [
					['concurrent:preserver', 'shell:backend']
					['watch']
				]
			options:
				logConcurrentOutput: true

		newer:
			options:
				override: (info, include) ->
					if info.task == 'shell' and info.target == 'pytest'
						source = info.path.replace /_test\.py$/, '.py'
						fs.stat source, (error, stats) ->
							if error?.code
								grunt.log.error "#{error.code} #{error.path} (#{error.syscall})"
							if stats.mtime.getTime() > info.time.getTime()
								include yes
							else
								include no
					else
						include no

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-handlebars'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-compile-handlebars' # compile, not contrib
	grunt.loadNpmTasks 'grunt-sass'
	grunt.loadNpmTasks 'grunt-postcss'
	grunt.loadNpmTasks 'grunt-contrib-symlink'
	grunt.loadNpmTasks 'grunt-shell'
	grunt.loadNpmTasks 'grunt-concurrent'
	grunt.loadNpmTasks 'grunt-contrib-jasmine'
	grunt.loadNpmTasks 'grunt-casperjs'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-newer'
	grunt.loadTasks 'grunt-tasks'  # these are our own

	grunt.registerTask 'compile-base', [
		'handlebars:compile'
		'newer:coffee:compile'
		'sass:compile'
		'postcss:compile'
		'symlink:base'
	]
	grunt.registerTask 'compile', [
		'compile-base'
		'symlink:develop'
		'clean:develop'
		'compile-handlebars:develop'
	]
	grunt.registerTask 'dist', [
		'compile-base'
		'symlink:dist'
		'clean:dist'
		'compile-handlebars:dist'
		'requirejs:dist'
		'cssmin:dist'
	]
	grunt.registerTask 'server', ['shell:backend']
	grunt.registerTask 'default', ['concurrent:develop']
