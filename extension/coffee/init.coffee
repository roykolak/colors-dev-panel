model = new Backbone.Model
  color: '#4573D5'
  steps: 40
  blendColor: '#D54545'
  sitePalette: ['#CCC']

if chrome.runtime?
  port = chrome.runtime.connect()

  port.postMessage("Request Tab Data")
  port.onMessage.addListener (msg) ->
    model.set sitePalette: msg

$ ->

  colorView = new Panel.Views.ColorView model: model
  $('.side').html colorView.render().el

  sitePaletteView = new Panel.Views.SitePaletteView model: model
  $('.side').prepend sitePaletteView.render().el

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

  $('.main').html tabView.render().el
