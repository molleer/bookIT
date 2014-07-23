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
  $('.preview_mail').click (e) ->
    e.preventDefault()
    form = $(this).parent()
    params = form.serialize()
    $.get "#{form.prop('action')}?#{params}", (data) ->
      form.remove()
      $('form.hidden').removeClass('hidden')
      $('.message-preview').text(data)

showEmail = (mail, url, id) ->
  $('#email').val(mail)
  $('#link').val(url)
  $form = $('#mail_form form')
  $form.attr('action', $form.data('url').replace('$$', id))
  $('#mail_form').reveal()
