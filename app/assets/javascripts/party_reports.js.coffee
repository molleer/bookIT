# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('[disabled]').on 'click', ->
		return false
	$('.reject').click ->
		$this = $(this)
		showEmail $this.data('mail'), $this.data('url'), $this.data('id')
		return false
	$('.send_bookings').click ->
		$('#send_form').reveal()
