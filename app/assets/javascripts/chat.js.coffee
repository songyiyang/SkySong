class SkySong.Chat

  @pageInit: ->
    $("#hide-controls").hide()
    $("#controls").hide()

  @windowInitListener: ->
    if $(window).width() < 750
      wid = $(window).width()-80
      $("#chat").css("width", wid)
      $("#input-form").css("width", wid-200)
      msg = "Please use Full Screen or change window size( Command + '-' or
              Ctrl + '-' ) to see the Outputs."
      SkySong.Msg.drawMsg(msg, '.notice', 'gray')
    if ($('#draw').position().left + 700) > $('#sharedCanvas').position().left
      $('#sharedCanvas').hide()

  @windowResizeListener: ->
    if (($('#draw').position().left + 700) > $('#sharedCanvas').position().left) && $(window).width() < 1288
      $('#sharedCanvas').hide()
      SkySong.Msg.drawMsg("Please Use Full Screen or change window size( Command + '-' or Ctrl + '-' ) to see the Outputs.", '.notice', 'gray')
      $("html, body").animate({ scrollTop: 0 }, "slow")
    else
      $('#sharedCanvas').show()
      $('.notice').fadeOut('slow')
    if $(window).width() < 750
      wid = $(window).width()-80
      $("#chat").css("width", wid)
      $("#input-form").css("width",$(window).width()-280)
    else
      $("#chat").css("width", "100%")

  @userInitDiff: ->
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

  @pageConnectionCheck: ->
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
            window.location = "/main"
    , 2000)

  @pageShowListener: ->
    $("#controls").show()
    $("#show-controls").hide()
    $("#hide-controls").show()
    $("html, body").animate({ scrollTop: $(document).height() }, 1500)

  @pageHideListener: ->
    $("#controls").hide()
    $("#hide-controls").hide()
    $("#show-controls").show()

  @disconnectListener: ->
    $.ajax(
      url: '/disconnect'
      type: 'GET'
      dataType: 'json'
    )
    .done (response) ->
      window.location = "/main"

  @sendImgListener: ->
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
      $("html, body").animate({ scrollTop: 0 }, "slow")

  @chatDomListener: (event) ->
    name = if event.target.getElementsByClassName("skyer_1").length == 0 then event.target.getElementsByClassName("skyer_2") else event.target.getElementsByClassName("skyer_1")
    if $("#myCanvas").css("border-color") == "rgb(41, 128, 185)" && name[0].innerText != "You : " && name[0].getAttribute("class") == "skyer_1"
      name[0].style.color = 'red'
      name[0].innerText = "You : "
    else if $("#myCanvas").css("border-color") == "rgb(26, 188, 156)" && name[0].innerText != "You : " && name[0].getAttribute("class") == "skyer_2"
      name[0].innerText = "You : "
      name[0].style.color = 'red'
    $("#chat").animate({scrollTop: $("#chat")[0].scrollHeight}, 1000)



