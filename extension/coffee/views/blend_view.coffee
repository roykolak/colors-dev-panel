class Panel.Views.BlendView extends Backbone.View
  template:
    """
      <div class="heading">
        Showing <span class="steps_count">{{steps}}</span> steps to
        <input type="color" class="color_picker" id="color_picker" value="{{blendColor}}">
        <div class="copy_controls">
          copy as:
          <select class="copy_format">
            <option value="hex">hex</option>
            <option value="rgb">rgb</option>
            <option value="hsl">hsl</option>
          </select>
        </div>
      </div>
      <div class="range_colors"></div>
      <div class="range_controls">
        <input type="range" id="steps" class="steps" min="3" max="200" value="{{steps}}">
      </div>
    """

  events:
    "input #steps": "onStepsChange"
    "input #color_picker": "onBlendColorChange"

  initialize: ->
    @model.on 'change:color', @render, @
    @model.on 'change:steps', @renderColors, @
    @model.on 'change:blendColor', @renderColors, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colorsView = new Panel.Views.ColorsView
      colors: Panel.Lib.Color.blend(@model.toJSON())
      model: @model
    colorsView.on 'select', (color) =>
      @model.set color: color
    @$('.range_colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    $('.steps').text steps
    @$('.steps_count').text steps
    @model.set steps: steps

  onBlendColorChange: (ev) ->
    color = $(ev.currentTarget).val()
    $('.end_color').css background: color
    @model.set blendColor: color

  onCopyFormatChange: (ev) ->
    ev.preventDefault()
    @model.set copyFormat: $(ev.currentTarget).val()
