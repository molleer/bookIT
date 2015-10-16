# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
	unless window.top == window
		$('h1').first().hide()
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

	$('#calendar').fullCalendar
		events: '/bookings/calendar_data.json'
		defaultView: 'agendaWeek'
		firstDay: 1
		scrollTime: '10:00:00'
		axisFormat: 'HH:mm'

setFormValues = (activeRadio) ->
	fest = $(activeRadio).data 'fest'
	$('.party-container').toggle fest
	options = $('option', '#booking_group')
	options.first().attr('disabled', fest)

	# prevents a person to book rooms only to be booked by groups
	if fest
		if options.length > 1
			$('#booking_group').val(options[1].value)
		else
			$('#booking_group')[0].setCustomValidity('Lokalen kan ej bokas som privatperson')
	else
		$('#booking_group')[0].setCustomValidity('')

	# Disable booking_fest if not festrum
	$('#party').attr('checked', false) unless fest


	$('#party').trigger('change')
	# $('.party-info-container').toggle fest

formScripts = ->
	$('.party-info-container').show() if $('#party').prop('checked')
	$('.show-click').each ->
		return unless $(@).prop('checked')
		klass = $(@).data('show')
		$(klass).show()
		$(@).parent().hide()
	setFormValues($('.location-container input[type="radio"]:checked').first())

	$('.repeat-booking-container').show() if $('#repeat_booking').prop('checked')

	$('#repeat_booking').on 'change', ->
		$('.repeat-booking-container').toggle @checked

	$('.show-click').on 'change', ->
		klass = $(@).data('show')
		$(klass).show()
		$(@).parent().hide()

	$('.location-container').on 'change', 'input[type="radio"]', ->
		setFormValues(@)

	$('#party').on 'change', (e) ->
		$('.party-info-container').toggle @checked
		$('#booking_party_report_attributes_begin_date').val($('#booking_begin_date').val())
		$('#booking_party_report_attributes_end_date').val($('#booking_end_date').val())

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

