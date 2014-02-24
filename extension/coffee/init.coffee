model = new Backbone.Model
  color: '#4573D5'
  steps: 40
  blendColor: '#D54545'
  palette: []

if chrome.runtime?
  port = chrome.runtime.connect()

  port.postMessage("fetch_palette")
  port.onMessage.addListener (msg) ->
    model.set palette: msg

$ ->

  colorView = new Panel.Views.ColorView model: model
  $('.side').html colorView.render().el

  tabView = new Panel.Views.TabView model: model
  tabView.on 'selection', (selection) ->
    view = switch selection
      when 'palette'
        new Panel.Views.PaletteView(model: @model)
      when 'schemas'
        new Panel.Views.SchemaView(model: @model)
      when 'blend'
        new Panel.Views.BlendView(model: @model)
      else
        new Panel.Views.RangeView(model: @model, mode: selection)
    @update(view.render().el)
  , tabView

  $('.main').html tabView.render().el
