
$ ->
  $(window).on('beforeunload', ->
    $.ajax(
      async: false
      url: '/check_connect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      if response.msg != "Connected!" ||
      (response.msg == "Connected!" && window.location.pathname == '/chat')
        $.ajax(
          async: false
          url: '/clear_session'
          type: 'GET'
          dataType: 'json'
        )
        .done (response) ->
          response.msg
    return
  )

  if window.location.pathname == '/chat'
    setInterval(->
      $.ajax(
        url: '/check_connect'
        type: 'GET'
        dataType: 'json'
      )
      .done (response) ->
        if response.msg == "Disconnected!"
          SkySong.Msg.drawMsg(response.msg, '.alert')
          $.ajax(
            url: '/clear_session'
            type: 'GET'
            dataType: 'json'
          )
          .done ->
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
      SkySong.Msg.drawMsg(response.msg, '.notice')
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
            if response.msg == "Connected!"
              SkySong.Msg.drawMsg(response.msg, '.alert')
              window.location = "chat"
        , 2000)



  $('#chat').bind('DOMNodeInserted', (event) ->
    $("#chat").animate({scrollTop: $("#chat")[0].scrollHeight}, 1000)
    )

  penColor = "tomato"
  penSize = 5
  setPenColor = (event) ->
    penColor = event.target.id
    $("#size-preview").css background: penColor
    return

  setPenSize = (event) ->
    penSize = $(event.target).val()
    $("#size-preview").css
      width: penSize
      height: penSize

    return

  $("#colors").click setPenColor
  $("#size-slider").mouseup setPenSize
  canvas = document.getElementById("myCanvas")
  context = canvas.getContext("2d")
  imageObj = new Image()
  dragging = false
  prevX = undefined
  prevY = undefined
  imageObj.onload = ->
    context.drawImage imageObj, 0, 0, 900, 550
    return

  $("#canvas-button").click (event) ->
    event.preventDefault()
    imageObj.src = $("#canvas-input").val()
    $("#canvas-input").val ""
    false

  canvas.onmousedown = (e) ->
    e.preventDefault()
    dragging = true
    prevX = e.offsetX
    prevY = e.offsetY
    context.beginPath()
    context.moveTo e.offsetX, e.offsetY
    $.ajax(
      url: '/publish'
      type: 'GET'
      dataType: 'json'
      data:
        line_to: [e.offsetX, e.offsetY]
        active: 0
    )
    false

  canvas.onmousemove = (e) ->
    e.preventDefault()
    if dragging is true
      context.lineTo e.offsetX, e.offsetY
      context.lineWidth = penSize
      context.lineCap = "round"
      context.strokeStyle = penColor
      context.stroke()
      prevX = e.offsetX
      prevY = e.offsetY
      $.ajax(
        url: '/publish'
        type: 'GET'
        dataType: 'json'
        data:
          line_to: [e.offsetX, e.offsetY]
          active: 1
          line_width: penSize
          line_color: penColor
      )
    context.beginPath()
    context.moveTo e.offsetX, e.offsetY
    false

  canvas.onmouseup = (e) ->
    e.preventDefault()
    dragging = false
    context.lineTo e.offsetX, e.offsetY
    context.lineWidth = 8
    context.lineCap = "round"
    context.strokeStyle = "red"
    context.stroke()
    false


  # bind event handler to clear button
  document.getElementById("clear").addEventListener "click", (->
    context.clearRect 0, 0, canvas.width, canvas.height
    return
  ), false
