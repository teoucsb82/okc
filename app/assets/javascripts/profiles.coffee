# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  setClickListeners()
  
  $("#authenticate-link").bind 'ajax_finished', ->
    setClickListeners()
  return


setClickListeners = ->
  $('#authenticate-link a').bind "click", ->
    if $(this).text().match("In")
      $(this).text("Logging In...")
    else
      $(this).text("Logging Out...")
    return
  return
