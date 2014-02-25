class Panel.Views.PaletteView extends Backbone.View
  template:
    """
      <ul class="tabs">
        <li class="selected">
          <a href="#">Page Colors</a>
        </li>
      </ul>
      <a href="#" class="fetch_colors">Reload</a>
      <p class="palette_instructions">Select color to modify on page</p>
      <div class="range_colors"></div>
    """

  events:
    "click .fetch_colors": "onFetchColorsClick"

  initialize: ->
    @model.on 'change:palette', @render, @
    @model.on 'change:syncColor', @onSyncColorChange, @
    @fetchPalette()

  fetchPalette: ->
    if chrome.runtime?
      port = chrome.runtime.connect()
      port.postMessage(label: 'fetch_palette')
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

    colorsView.on 'select', (color, $el) =>
      @model.set
        color: color
        syncColor: color
        rangeStart: color
      colorsView.$('.selected').removeClass('selected')
      @$('.range_colors li').css opacity: 0.2
      $el.addClass('selected')
      $el.parent().css opacity: 1

    colorsView.on 'unselect', (color, $el) =>
      @model.unset 'syncColor'
      colorsView.$('.selected').removeClass('selected')
      @$('.range_colors li').css(opacity: 1)

    @$('.range_colors').html colorsView.render().el

  onReloadClick: (ev) ->
    ev.preventDefault()
    @model.set palette: []
    @fetchPalette()

  onSyncColorChange: ->
    unless @model.get('syncColor')?
      $('.range_colors .selected').removeClass('selected')

  onFetchColorsClick: (ev) ->
    ev.preventDefault()
    @fetchPalette()
