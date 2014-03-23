$ ->
  if window.location.pathname == '/chat'
    setInterval(->
      $.ajax(
        url: '/check_connect'
        type: 'GET'
        dataType: 'json'
      )
      .done (response) ->
        if response.channel == 0
          alert response.channel
          window.location = "/"
    , 2000)

  $("#disconnect").click ->
    $.ajax(
      url: '/disconnect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      window.location = "/"

  $("#connect").click ->
    $.ajax(
      url: '/connect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      alert response.channel
      if response.channel == 2
        window.location = "chat"
      else
        setInterval(->
          $.ajax(
            url: '/check_connect'
            type: 'GET'
            dataType: 'json'
          )
          .done (response) ->
            alert response.channel
            if response.channel == 2
              window.location = "chat"
        , 2000)



  $('#chat').bind('DOMNodeInserted', (event) ->
    $("#chat").animate({scrollTop: $("#chat")[0].scrollHeight}, 1000)
    )
