model = new Backbone.Model
  color: '#4573D5'
  rangeStart: '#4573D5'
  steps: 40
  blendColor: '#D54545'
  palette: []

model.on 'change:color', ->
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

$ ->
  colorView = new Panel.Views.ColorView model: model
  $('.side').html colorView.render().el

  paletteView = new Panel.Views.PaletteView model: model
  $('.middle').html paletteView.render().el

  colorControlsView = new Panel.Views.ColorControlsView model: model
  $('.middle').append colorControlsView.render().el

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
