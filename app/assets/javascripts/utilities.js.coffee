class SkySong.Utilities
  @unloadCheck: ->
    $.ajax(
      async: false
      url: '/check_connect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      if response.msg != "Connected!" ||
      (response.msg == "Connected!" && (window.location.pathname == '/chat' || window.location.pathname == '/chat_together'))
        $.ajax(
          async: false
          url: '/clear_session'
          type: 'GET'
          dataType: 'json'
        )
        .done (response) ->
          response.msg
    return
