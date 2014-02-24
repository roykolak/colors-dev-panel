chrome.extension.onMessage.addListener (message, sender) ->
  if message == 'fetch_palette'
    colors = []

    for el in document.body.querySelectorAll('*')
      for prop in ['color', 'backgroundColor']
        color = window.getComputedStyle(el)[prop]
        if color && color != 'transparent' && colors.indexOf(color) == -1
          colors.push color

    chrome.extension.sendMessage colors
