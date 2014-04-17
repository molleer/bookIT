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
	$('.party-info-container').show() if $('#booking_party').prop('checked')
	$('.location-container').on 'change', 'input[type="radio"]', ->
		fest = $(@).data 'fest'
		$('.party-container').toggle fest

		# Disable booking_fest if not festrum
		$('#booking_party').attr('checked', false) unless fest

		$('#booking_party').trigger('change')
		# $('.party-info-container').toggle fest
	$('#booking_party').on 'change', (e) ->
		$('.party-info-container').toggle @checked
	for name, value of JSON.parse(localStorage.getItem 'bookITStorage')
		$elem = $("\##{name}")
		if $elem.val().length == 0
			$elem.val(value)
	$('form').on 'submit', (e) ->
		return unless window.localStorage
		store = {}
		$('input').each ->
			$this = $(@)
			if $this.data 'persist'
				store[$this.attr('id')] = $this.val() if $this.val().length > 0
		localStorage.setItem 'bookITStorage', JSON.stringify store
