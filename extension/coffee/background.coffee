chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (message) ->
    chrome.tabs.query currentWindow: true, active: true, (tabs) ->
      chrome.tabs.sendMessage(tabs[0].id, message)

  chrome.extension.onMessage.addListener (message, sender) ->
    port.postMessage(message)
