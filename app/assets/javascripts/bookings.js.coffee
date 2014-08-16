# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
	if $('.page-bokning')[0]
		formScripts()

	$('.bookings-index').on 'click', 'a.others', (e) ->
		$this = $(@)
		id = $this.data('id')
		$form = $('#mail_form form')
		$form.attr('action', $form.data('url').replace('$$', id))
		$('#booking_title').text($this.parent().find('strong a').text())
		$('#mail_form').reveal()
		return false

setFormValues = (activeRadio) ->
	fest = $(activeRadio).data 'fest'
	$('.party-container').toggle fest
	options = $('option', '#booking_group')
	options.first().attr('disabled', fest)

	# prevents a person to book rooms only to be booked by groups
	if options.length > 1
		$('#booking_group').val(options[1].value)
	else
		$('#booking_group')[0].setCustomValidity('Lokalen kan ej bokas som privatperson')


	# Disable booking_fest if not festrum
	$('#booking_party').attr('checked', false) unless fest


	$('#booking_party').trigger('change')
	# $('.party-info-container').toggle fest

formScripts = ->
	$('.party-info-container').show() if $('#booking_party').prop('checked')
	setFormValues($('.location-container input[type="radio"]:checked').first())



	$('.location-container').on 'change', 'input[type="radio"]', ->
		setFormValues(@)


	$('#booking_party').on 'change', (e) ->
		$('.party-info-container').toggle @checked
	if window.location.href.match /new/
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


	# dis amount of UX... changes end_date to begin_date if end_date > begin_date
	$('.booking-dates-container').on 'change', 'input', ->
		$this = $(@)
		$other = $('.booking-dates-container input').not($this)
		begin_date = $('#booking_begin_date')
		end_date = $('#booking_end_date')
		if begin_date.val() > end_date.val()
			if $this.is(begin_date)
				end_date.val(begin_date.val())
			else
				begin_date.val(end_date.val())
