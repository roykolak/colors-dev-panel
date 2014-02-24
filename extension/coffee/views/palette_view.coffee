class Panel.Views.PaletteView extends Backbone.View
  template:
    """
      <div class="range_colors"></div>
    """

  initialize: ->
    @model.on 'change:palette', @render, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colorsView = new Panel.Views.ColorsView
      model: @model
      colors: @model.get('palette')
    @$('.range_colors').html colorsView.render().el
