$ ->
  $(window).on('beforeunload', SkySong.Utilities.unloadCheck)

  if window.location.pathname == '/chat'
    SkySong.Chat.pageInit()
    SkySong.Chat.userInitDiff()
    SkySong.Chat.windowInitListener()
    SkySong.Chat.pageConnectionCheck()
    $(window).resize(SkySong.Chat.windowResizeListener)
    $("#show-controls").click(SkySong.Chat.pageShowListener)
    $("#hide-controls").click(SkySong.Chat.pageHideListener)
    $("#disconnect").click(SkySong.Chat.disconnectListener)
    $("#send-img").click(SkySong.Chat.sendImgListener)
    $('#chat').bind('DOMNodeInserted', SkySong.Chat.chatDomListener)
  else if window.location.pathname == '/main'
    $("#connect").click(SkySong.Main.connectListener)

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

  if window.location.pathname == '/chat'
    $("#colors").click setPenColor
    $("#size-slider").mouseup setPenSize
    canvas = document.getElementById("myCanvas")
    context = canvas.getContext("2d")
    dragging = false
    prevX = undefined
    prevY = undefined

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
      false

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
