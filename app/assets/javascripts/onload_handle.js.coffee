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
    if $(window).width() < 750
      wid = $(window).width()-80
      $("#chat").css("width", wid)
      $("#input-form").css("width", wid-200)
      msg = "Please use Full Screen or change window size( Command + '-' or
              Ctrl + '-' ) to see the Outputs."
      SkySong.Msg.drawMsg(msg, '.notice', 'black')

  if window.location.pathname == '/'
    $("#img-stuff").empty
    $.ajax(
      url: "/xkcd"
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      $("#img-stuff").css("background-image", "url('http://imgs.xkcd.com/comics/mattress.png')")

  $("#send-img").click ->
    canvas1 = document.getElementById("sharedCanvas1")
    canvas2 = document.getElementById("sharedCanvas2")
    image1 = canvas1.toDataURL("image/png")
    image2 = canvas2.toDataURL("image/png")
    $.ajax(
      url: '/send_img'
      type: 'post'
      dataType: 'json'
      data:
        image_1: image1
        image_2: image2
    )
    .done (response) ->
      SkySong.Msg.drawMsg(response.msg, '.alert', 'green')
      $('.alert').fadeOut(5000)

  if window.location.pathname == '/chat'
    if ($('#draw').position().left + 700) > $('#sharedCanvas').position().left
      $('#sharedCanvas').hide()
    $(window).resize ->
      if (($('#draw').position().left + 700) > $('#sharedCanvas').position().left) && $(window).width() < 1288
        $('#sharedCanvas').hide()
        SkySong.Msg.drawMsg("Please Use Full Screen or change window size( Command + '-' or Ctrl + '-' ) to see the Outputs.", '.notice', 'black')
      else
        $('#sharedCanvas').show()
        $('.notice').fadeOut('slow')
      if $(window).width() < 750
        wid = $(window).width()-80
        $("#chat").css("width", wid)
        $("#input-form").css("width",$(window).width()-280)
      else
        $("#chat").css("width", "100%")

  if window.location.pathname == '/chat'
    $.ajax(
      url: '/color_diff'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      color = ""
      $("#chat").css("border", "2px solid #{response.color}")
      $("#myCanvas").css("border", "2px solid #{response.color}")
      $("#input-form").css("border", "2px solid #{response.color}")
      $(".send-btn").css("background", "#{response.color}")
      if response.color == "#1abc9c"
        color = "Greener"
        $("#title-msg").css("color", "green")
      else
        color = "Bluer"
        $("#title-msg").css("color", "blue")
      $("#title-msg").text("#{color}: ")

    setInterval(->
      $.ajax(
        url: '/check_connect'
        type: 'GET'
        dataType: 'json'
      )
      .done (response) ->
        if response.msg == "Disconnected!"
          SkySong.Msg.drawMsg(response.msg, '.alert', 'red')
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
      $("html, body").animate({ scrollTop: $(document).height() }, "slow")
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
      SkySong.Msg.drawMsg(response.msg, '.alert', 'green')
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
              SkySong.Msg.drawMsg(response.msg, '.notice', 'green')
              window.location = "chat"
        , 2000)


  $('#chat').bind('DOMNodeInserted', (event) ->
    name = if event.target.getElementsByClassName("skyer_1").length == 0 then event.target.getElementsByClassName("skyer_2") else event.target.getElementsByClassName("skyer_1")
    if $("#myCanvas").css("border-color") == "rgb(41, 128, 185)" && name[0].innerText != "You : " && name[0].getAttribute("class") == "skyer_1"
      name[0].style.color = 'red'
      name[0].innerText = "You : "
    else if $("#myCanvas").css("border-color") == "rgb(26, 188, 156)" && name[0].innerText != "You : " && name[0].getAttribute("class") == "skyer_2"
      name[0].innerText = "You : "
      name[0].style.color = 'red'
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
