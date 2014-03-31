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
      <div class="range_colors">
        <span>Text colors</span>
        <div class="color_values values"></div>
        <span>Background colors</span>
        <div class="backgroundColor_values values"></div>
      </div>
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
    for property in ['color', 'backgroundColor']
      colorsView = new Panel.Views.ColorsView
        model: @model
        colors: @model.get('palette')[property]
        draggable: false
        droppable: true
        cssProperty: property

      colorsView.on 'select', (color, $el) =>
        @model.set
          color: color
          syncColor: color
          rangeStart: color
        colorsView.$('.selected').removeClass('selected')
        @$('.range_colors li').css opacity: 0.2
        $el.addClass('selected')
        $el.css opacity: 1

      colorsView.on 'unselect', (color, $el) =>
        @model.unset 'syncColor'
        colorsView.$('.selected').removeClass('selected')
        @$('.range_colors li').css(opacity: 1)

      if chrome.runtime?
        colorsView.on 'mouseover', (color, $el, cssProperty) =>
          port = chrome.runtime.connect()
          port.postMessage
            label: 'color_to_sync_highlight'
            color: color
            cssProperty: cssProperty

        colorsView.on 'mouseout', (color, $el, cssProperty) =>
          port = chrome.runtime.connect()
          port.postMessage
            label: 'color_to_sync_unhighlight'
            color: color
            cssProperty: cssProperty

      @$(".range_colors .#{property}_values").html colorsView.render().el

  onReloadClick: (ev) ->
    ev.preventDefault()
    @model.set palette: []
    @fetchPalette()

  onSyncColorChange: ->
    if @model.get('syncColor')?
      @$('.range_colors .selected').removeClass('selected')
      @$('.range_colors li').css opacity: 0.2
      $el = @$("li[data-color='#{@model.get('syncColor')}']")
      $el.addClass('selected')
      $el.css opacity: 1
    else
      @$('.range_colors .selected').removeClass('selected')
      @$('.range_colors li').css opacity: 1

  onFetchColorsClick: (ev) ->
    ev.preventDefault()
    @fetchPalette()
