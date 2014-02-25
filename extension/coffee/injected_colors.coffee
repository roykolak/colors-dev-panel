colorElementMap = {}

properties = ['color', 'backgroundColor']

chrome.extension.onMessage.addListener (message, sender) ->
  switch message.label
    when 'fetch_palette'
      colorElementMap = color: {}, backgroundColor: {}
      colors = []
      for el in document.body.querySelectorAll('*')
        for prop in properties
          color = window.getComputedStyle(el)[prop]
          if color && color != 'transparent'
            colorElementMap[prop][color] ?= []
            colorElementMap[prop][color].push el
            colors.push color if colors.indexOf(color) == -1

      chrome.extension.sendMessage colors
    when 'sync'
      for prop in properties
        for color in message.color
          for el in colorElementMap[prop][color] || []
            el.style[prop] = message.newColor
