colorElementMap = {}
interval = null

properties = ['color', 'backgroundColor']

chrome.extension.onMessage.addListener (message, sender) ->
  switch message.label
    when 'fetch_palette'
      colorElementMap = color: {}, backgroundColor: {}
      colors = color: [], backgroundColor: []

      for el in document.body.querySelectorAll('*')
        for prop in properties
          color = window.getComputedStyle(el)[prop]
          if color && color != 'transparent'
            colorElementMap[prop][color] ?= []
            colorElementMap[prop][color].push el
            colors[prop].push color if colors[prop].indexOf(color) == -1

      chrome.extension.sendMessage colors

    when 'sync'
      for prop in properties
        for color in message.color
          for el in colorElementMap[prop][color] || []
            el.style[prop] = message.newColor

    when 'color_to_sync_selected'
      for prop in properties
        for color in message.color
          for el in colorElementMap[prop][color] || []
            bringAttentionToEl(el)

    when 'color_to_sync_highlight'
      {cssProperty, color} = message
      for el in colorElementMap[cssProperty][color] || []
        bringAttentionToEl(el, color, cssProperty)

    when 'color_to_sync_unhighlight' then
      # Nothing for now

bringAttentionToEl = (el, color, cssProperty) ->
  el.style[cssProperty] = 'transparent'
  setTimeout (-> el.style[cssProperty] = color), 250
