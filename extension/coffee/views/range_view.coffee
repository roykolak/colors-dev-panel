class Panel.Views.RangeView extends Backbone.View
  template:
    """
      <div class="range_colors"></div>
      <div class="range_controls">
        <input type="range" id="steps" min="3" max="200" value="{{steps}}">
        <span><span class="steps">{{steps}}</span> steps</span>
      </div>
    """

  events:
    "input #steps": "onStepsChange"

  initialize: (options) ->
    @mode = options.mode
    @model.on 'change:steps', @renderColors, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colors = Panel.Lib.Color[@mode](@model.toJSON())
    colorsView = new Panel.Views.ColorsView(colors: colors)
    @$('.range_colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    $('.steps').text steps
    @model.set steps: steps

