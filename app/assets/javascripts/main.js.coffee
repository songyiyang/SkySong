class SkySong.Main
  @connectListener: ->
    $.ajax(
      url: '/connect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      SkySong.Msg.drawMsg(response.msg, '.alert', 'green')
      if response.channel == 2
        window.location = "chat"
      else
        $("#connect").text("Waiting...")
        setInterval(->
          $.ajax(
            url: '/check_connect'
            type: 'GET'
            dataType: 'json'
          )
          .done (response) ->
            if response.msg == "Connected!"
              $('.alert').fadeOut("fast")
              SkySong.Msg.drawMsg(response.msg, '.notice', 'green')
              window.location = "chat"
        , 2000)

  @togetherListener: ->
    $.ajax(
      url: '/connect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      SkySong.Msg.drawMsg(response.msg, '.alert', 'green')
      if response.channel == 2
        window.location = "chat_together"
      else
        $("#connect").text("Waiting...")
        setInterval(->
          $.ajax(
            url: '/check_connect'
            type: 'GET'
            dataType: 'json'
          )
          .done (response) ->
            if response.msg == "Connected!"
              $('.alert').fadeOut("fast")
              SkySong.Msg.drawMsg(response.msg, '.notice', 'green')
              window.location = "chat_together"
        , 2000)