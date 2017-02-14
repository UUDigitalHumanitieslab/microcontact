###
	(c) 2016 Julian Gonggrijp
###

casper.test.begin 'The visitor is welcomed to the index page', (test) ->
	casper.start 'http://localhost:8000'
	casper.then () ->
		casper.waitForSelectorTextChange 'main'
	casper.then () ->
		test.assertTitle 'Microcontact'
		test.assertExists 'h1'
		test.assertSelectorHasText 'h1', 'Microcontact'
		test.assertTextExists 'Welcome'
	casper.run () ->
		test.done()
