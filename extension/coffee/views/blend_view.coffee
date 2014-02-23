class Panel.Views.BlendView extends Backbone.View
  template:
    """
      <div class="colors"></div>
      <div class="range_controls">
        <input type="color" class="color_picker" id="color_picker" value="{{blendColor}}">
        <input type="range" id="steps" min="3" max="1000" value="20">
        <span><span class="steps">{{steps}}</span> steps</span>
      </div>
    """

  events:
    "input #steps": "onStepsChange"
    "input #color_picker": "onBlendColorChange"

  initialize: ->
    @model.on 'change:steps', @renderColors, @
    @model.on 'change:blendColor', @renderColors, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colors = Panel.Lib.Color.blend(@model.toJSON())
    colorsView = new Panel.Views.ColorsView(colors: colors)
    @$('.colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    $('.steps').text steps
    @model.set steps: steps

  onBlendColorChange: (ev) ->
    @model.set blendColor: $(ev.currentTarget).val()

