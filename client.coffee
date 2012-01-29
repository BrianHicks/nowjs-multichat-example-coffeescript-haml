$(document).ready ->
  now.receiveMessage = (name, message) ->
    $('#messages').append "<p>" + name + ":" + message + "</p>"

  $("#send-button").click ->
    now.distributeMessage $("#text-input").val()
    $("$text-input").val ""

  $(".change").click ->
    now.changeRoom $(this).text()

  now.name = prompt "What's your name?", ""
