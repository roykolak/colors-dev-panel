chrome.runtime.onConnect.addListener (devToolsConnection) ->
  devToolsListener = (message, sender, sendResponse) ->
    console.log message
    chrome.tabs.executeScript message.tabId, file: message.scriptToInject

  devToolsConnection.onMessage.addListener(devToolsListener)
console.log 'yo'
