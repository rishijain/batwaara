# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->

  class_for_settlements = ->
    if $('#bill_event_id :selected').text() == 'Settlement'
      $('.settlement_block').removeClass 'hide'
      $('.not_settlement_block').addClass 'hide'
    else
      $('.settlement_block').addClass 'hide'
      $('.not_settlement_block').removeClass 'hide'
  $(".alert" ).fadeOut(3000);

  class_for_settlements()

  $('#bill_event_id').change ->
    class_for_settlements()
