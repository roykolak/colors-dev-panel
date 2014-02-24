chrome.extension.onMessage.addListener (message, sender) ->
  colors = []

  for el in document.body.querySelectorAll('*')
    if el.style.color && el.style.color != 'transparent'
      colors.push el.style.color if colors.indexOf(el.style.color) == -1
    if el.style.backgroundColor && el.style.backgroundColor != 'transparent'
      colors.push el.style.backgroundColor if colors.indexOf(el.style.backgroundColor) == -1

  chrome.extension.sendMessage colors
