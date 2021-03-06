chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (message) ->
    switch message.label
      when 'retrieve_state'
        chrome.storage.sync.get null, (data) ->
          port.postMessage(data)
      when 'save_state'
        chrome.storage.sync.set
          color: message.data.color
          recentColors: message.data.recentColors

      when 'open_contribute'
        chrome.tabs.create
          url: message.data.url
      else
        chrome.tabs.query currentWindow: true, active: true, (tabs) ->
          chrome.tabs.sendMessage(tabs[0].id, message)

  chrome.extension.onMessage.addListener (message, sender) ->
    port.postMessage(message)

  chrome.tabs.onActivated.addListener ->
    port.postMessage label: 'reload_palette'

  chrome.tabs.onUpdated.addListener ->
    port.postMessage label: 'reload_palette'
