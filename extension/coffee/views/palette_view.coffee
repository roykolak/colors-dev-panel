class Panel.Views.PaletteView extends Backbone.View
  template:
    """
      <ul class="tabs">
        <li class="selected">
          <a href="#">Page Colors</a>
        </li>
      </ul>
      <div class="range_colors"></div>
    """

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
      $el.addClass('selected')
    colorsView.on 'unselect', (color, $el) =>
      @model.unset syncColor: color
      colorsView.$('.selected').removeClass('selected')
    @$('.range_colors').html colorsView.render().el

  onReloadClick: (ev) ->
    ev.preventDefault()
    @model.set palette: []
    @fetchPalette()

  onSyncColorChange: ->
    unless @model.get('syncColor')?
      $('.range_colors .selected').removeClass('selected')
