chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (message) ->
    switch message.label
      when 'retrieve_state'
        chrome.storage.sync.get 'color', (data) ->
          port.postMessage(data.color)
      when 'save_state'
        chrome.storage.sync.set color: message.data
      else
        chrome.tabs.query currentWindow: true, active: true, (tabs) ->
          chrome.tabs.sendMessage(tabs[0].id, message)

  chrome.extension.onMessage.addListener (message, sender) ->
    port.postMessage(message)
