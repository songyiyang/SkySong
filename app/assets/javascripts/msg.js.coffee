class SkySong.Msg
  @drawMsg: (message, classType) ->
    $(classType).text(message)
    if message != "waiting..."
      $(classType).fadeIn('fast')
    else
      $(classType).fadeIn('fast')
    # if classType == '.notice'
    #   $(classType).delay(2000).fadeOut('slow')
    # else $(classType).delay(3000).fadeOut('slow')

