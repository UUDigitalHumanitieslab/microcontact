###
	(c) 2019 Digital Humanities Lab, Utrecht University
	Author: Julian Gonggrijp
###

define [
	'jquery'
	'bootstrap/popover'
], ($) ->
	# the following logic is documented in
	# https://getbootstrap.com/docs/3.4/javascript/#js-sanitizer
	defaultWhitelist = $.fn.tooltip?.Constructor?.DEFAULTS?.whiteList
	return unless defaultWhitelist?
	defaultWhitelist.table ?= []
	defaultWhitelist.thead ?= []
	defaultWhitelist.tbody ?= []
	defaultWhitelist.tfoot ?= []
	defaultWhitelist.tr ?= []
	defaultWhitelist.td ?= []
	defaultWhitelist.td.push 'style' unless 'style' in defaultWhitelist.td
