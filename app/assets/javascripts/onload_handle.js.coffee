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
  $("#hide-controls").hide()
  $("#controls").hide()
  $("#show-controls").click ->
    $("#controls").show()
    $("#show-controls").hide()
    $("#hide-controls").show()
  $("#hide-controls").click ->
    $("#controls").hide()
    $("#hide-controls").hide()
    $("#show-controls").show()


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
      SkySong.Msg.drawMsg(response.msg, '.alert')
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
              $('.alert').fadeOut("fast")
              SkySong.Msg.drawMsg(response.msg, '.notice')
              window.location = "chat"
        , 2000)



  $('#chat').bind('DOMNodeInserted', (event) ->
    $("#chat").animate({scrollTop: $("#chat")[0].scrollHeight}, 1000)
    )

  checkOffset = (event) ->
    unless event.hasOwnProperty("offsetX")
      event.offsetX = event.layerX - event.currentTarget.offsetLeft
      event.offsetY = event.layerY - event.currentTarget.offsetTop

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

  canvas.onmousedown = (event) ->
    event.preventDefault()
    checkOffset event
    dragging = true
    prevX = event.offsetX
    prevY = event.offsetY
    context.beginPath()
    context.moveTo event.offsetX, event.offsetY
    false

  canvas.onmousemove = (event) ->
    event.preventDefault()
    checkOffset event
    if dragging is true
      context.lineTo event.offsetX, event.offsetY
      context.lineWidth = penSize
      context.lineCap = "round"
      context.strokeStyle = penColor
      context.stroke()
      $.ajax(
        url: '/publish'
        type: 'GET'
        dataType: 'json'
        data:
          line_to: [(event.offsetX/2), (event.offsetY/2)]
          prev: [(prevX/2), (prevY/2)]
          line_width: penSize/2
          line_color: penColor
      )
      prevX = event.offsetX
      prevY = event.offsetY
    context.beginPath()
    context.moveTo event.offsetX, event.offsetY
    false

  canvas.onmouseup = (event) ->
    event.preventDefault()
    checkOffset event
    dragging = false
    # context.lineTo event.offsetX, event.offsetY
    # context.lineWidth = 8
    # context.lineCap = "round"
    # context.strokeStyle = "red"
    # context.stroke()
    false


  # bind event handler to clear button
  document.getElementById("clear").addEventListener "click", (->
    context.clearRect 0, 0, canvas.width, canvas.height
    $.ajax(
      url: '/clear'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      theCanvas = document.getElementById("sharedCanvas#{response.canvas}")
      context = theCanvas.getContext("2d")
      context.clearRect 0, 0, theCanvas.width, theCanvas.height
    return
  ), false
