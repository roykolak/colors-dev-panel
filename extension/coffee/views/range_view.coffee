class Panel.Views.RangeView extends Backbone.View
  template:
    """
      <div class="range_colors"></div>
      <div class="range_controls">
        <input type="range" id="steps" class="steps" min="3" max="200" value="{{steps}}">
      </div>
    """

  events:
    "input #steps": "onStepsChange"

  initialize: (options) ->
    @mode = options.mode
    @model.on 'change:steps', @renderColors, @
    @model.on 'change:rangeStart', @render, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colorsView = new Panel.Views.ColorsView
      model: @model
      colors: Panel.Lib.Color[@mode](@model.toJSON())
    colorsView.on 'select', (color) =>
      @model.set color: color
    @$('.range_colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    @model.set steps: steps
