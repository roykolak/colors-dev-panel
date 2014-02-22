chrome.devtools.panels.create 'Colors', null, 'panels/color.html', null
onShown.addListener ->
  backgroundPageConnection = chrome.runtime.connect()
  backgroundPageConnection.onMessage.addListener (message) ->
  alert chrome.devtools.inspectedWindow.tabId

  chrome.runtime.sendMessage
    tabId: chrome.devtools.inspectedWindow.tabId,
    scriptToInject: "js/injected_colors.js"
