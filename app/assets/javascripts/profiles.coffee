# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.scanner = undefined
  setClickListeners()

  $("#authenticate-link").bind 'ajax_finished', ->
    setClickListeners()
    return

  $("#scan-link").bind "ajax:success", ->
    startScan()
  return


setClickListeners = ->
  $('#authenticate-link a').bind "click", ->
    if $(this).text().match("In")
      $(this).text("Logging In...")
    else
      $(this).text("Logging Out...")
    return

  $('#scan-link').bind "click", (e) ->
    e.preventDefault()
    if $(this).text().match("Scanning") && e.originalEvent
      stopScan()
      $(this).addClass("btn-success").removeClass("btn-warning").html("<i class='fa fa-play-circle'></i> <span>Start scan</span>")
      $("#scanner-status").remove()
    else
      $(this).removeClass("btn-success").addClass("btn-warning").html("<span>Scanning... </span><i class='fa fa-spinner fa-spin'></i> ")
  return

startScan = ->
  window.scanner = setTimeout((->
    $("#scan-link").click()
    return
  ), 3000)
  return

stopScan = ->
  clearTimeout(window.scanner)
  return
