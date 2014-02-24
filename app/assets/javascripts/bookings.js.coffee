# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
	loaded = false
	Modernizr.load 
		test: Modernizr.inputtypes["datetime-local"]
		nope: ['/assets/jquery.datetimepicker.js', '/assets/jquery.datetimepicker.css']
		callback: ->
			if !loaded
				loaded = true
				defaults = 
					format: 'Y-m-d\\TH:i'
					step: 30
					dayOfWeekStart: 1
					todayButton: true
					minDate: '-1970/01/01'
				$('#booking_begin_date').datetimepicker defaults
				$('#booking_end_date').datetimepicker defaults
	$('.location-container').on 'change', 'input[type="radio"]', ->
		fest = $(@).data 'fest'
		$('.party-container').toggle fest

		# Disable booking_fest if not festrum
		$('#booking_fest').attr('checked', false) unless fest

		$('#booking_fest').trigger('change')
		# $('.party-info-container').toggle fest
	$('#booking_fest').on 'change', (e) ->
		$('.party-info-container').toggle @checked
