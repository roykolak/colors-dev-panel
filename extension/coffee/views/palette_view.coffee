class Panel.Views.PaletteView extends Backbone.View
  template:
    """
      <div class="palette_controls">
        Found <span class="amount">{{amount}}</span> unique colors on the current page
        <a href="#" class="reload">Reload palette</a>
      </div>
      <div class="range_colors"></div>
    """

  events:
    "click .reload": "onReloadClick"

  initialize: ->
    @model.on 'change:palette', @render, @
    @fetchPalette()

  fetchPalette: ->
    if chrome.runtime?
      port = chrome.runtime.connect()
      port.postMessage("fetch_palette")
      port.onMessage.addListener (msg) =>
        @model.set palette: msg

  render: ->
    @$el.html Mustache.render @template, _.extend {}, @model.toJSON(),
      amount: @model.get('palette').length
    @renderColors()
    this

  renderColors: ->
    colorsView = new Panel.Views.ColorsView
      model: @model
      colors: @model.get('palette')
    @$('.range_colors').html colorsView.render().el

  onReloadClick: (ev) ->
    ev.preventDefault()
    @model.set palette: []
    @fetchPalette()
