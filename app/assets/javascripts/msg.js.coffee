class SkySong.Msg
  @drawMsg: (message, classType, color) ->
    $(classType).text(message)
    $(classType).css("color", color)
    if message != "waiting..."
      $(classType).fadeIn('fast')
    else
      $(classType).fadeIn('fast')
