###
	(c) 2016 Julian Gonggrijp
	(c) 2017 Digital Humanities Lab, Utrecht University
###

casper.test.begin 'The visitor is welcomed with a map', (test) ->
	casper.start 'http://localhost:8000'
	casper.then () ->
		casper.waitForSelectorTextChange 'main'
	casper.then () ->
		test.assertTitle 'Microcontact'
		test.assertExists '#map'
		test.assertResourceExists 'maps.google.com/maps-api-v3/api/js'
		casper.waitForSelectorTextChange '#map'
	casper.then ->
		test.assertResourceExists 'google4.png'
		test.assertResourceExists 'maps.google.com/maps/vt'
	casper.run () ->
		test.done()
