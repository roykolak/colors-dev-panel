model = new Backbone.Model
  color: '#4573D5'
  rangeStart: '#4573D5'
  steps: 40
  blendColor: '#D54545'
  palette:
    color: ['#CCC', '#000']
    backgroundColor: ['#FFF']
  copyFormat: 'hex'
  tab: 'lighten'
  pageColorsCollapsed: false

recentColors = new Backbone.Collection

model.on 'change:color', ->
  recentColors.add new Backbone.Model
    color: model.get('color')
  if model.get('syncColor')
    if chrome.runtime?
      color = model.get('syncColor')
      chrome.runtime.connect().postMessage
        label: 'sync'
        color: [
          Panel.Lib.Color.toHexCSS color
          Panel.Lib.Color.toRgbCSS color
          Panel.Lib.Color.toHslCSS color
        ]
        newColor: model.get('color')

model.on 'change:syncColor', ->
  if chrome.runtime? && model.get('syncColor')
    color = model.get('syncColor')
    chrome.runtime.connect().postMessage
      label: 'color_to_sync_selected'
      color: [
        Panel.Lib.Color.toHexCSS color
        Panel.Lib.Color.toRgbCSS color
        Panel.Lib.Color.toHslCSS color
      ]

if chrome.runtime?
  port = chrome.runtime.connect()
  port.postMessage(label: 'retrieve_state')

  port.onMessage.addListener (data) =>
    if data.label == 'reload_palette'
      port.postMessage(label: 'fetch_palette')
      port.onMessage.addListener (msg) =>
        @model.set palette: msg
    else
      model.set data.color
      recentColors.reset data.recentColors

  model.on 'change', ->
    port.postMessage label: 'save_state', data:
      color: model.toJSON()
      recentColors: recentColors.toJSON().splice(0, 20)

  $ ->
    $('.contribute').click (ev) ->
      ev.preventDefault()
      port.postMessage label: 'open_contribute', data:
        url: $(ev.currentTarget).attr('href')

$ ->
  colorView = new Panel.Views.ColorView model: model
  $('.side').html colorView.render().el

  colorControlsView = new Panel.Views.ColorControlsView model: model
  $('.side').append colorControlsView.render().el

  recentColorsView = new Panel.Views.RecentColorsView
    collection: recentColors
    model: model
  $('.side').prepend recentColorsView.render().el


  paletteView = new Panel.Views.PaletteView model: model
  $('.middle').html paletteView.render().el

  tabView = new Panel.Views.TabView model: model
  tabView.on 'selection', (selection) ->
    view = switch selection
      when 'schemas'
        new Panel.Views.SchemaView(model: @model)
      when 'blend'
        new Panel.Views.BlendView(model: @model)
      else
        new Panel.Views.RangeView(model: @model, mode: selection)
    @update(view.render().el)
  , tabView

  $('.main').append tabView.render().el
