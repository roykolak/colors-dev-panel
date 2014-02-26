class Panel.Views.RangeView extends Backbone.View
  template:
    """
      <div class="heading">
        Showing <span class="steps_count">{{steps}}</span> steps to <span class="end_color" style="background: {{endColor}};"></span>
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
    "change .copy_format": "onCopyFormatChange"

  initialize: (options) ->
    @mode = options.mode
    @model.on 'change:steps', @renderColors, @
    @model.on 'change:rangeStart', @render, @

  render: ->
    endColor = switch @mode
      when 'lighten' then '#FFF'
      when 'darken' then '#000'
      when 'saturate' then '#FFF'
      when 'desaturate' then '#FFF'

    @$el.html Mustache.render @template, _.extend {}, @model.toJSON(),
      endColor: endColor
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
    @$('.steps_count').text steps
    @model.set steps: steps

  onCopyFormatChange: (ev) ->
    ev.preventDefault()
    @model.set copyFormat: $(ev.currentTarget).val()
