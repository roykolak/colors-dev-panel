class Panel.Views.ColorView extends Backbone.View
  template:
    """
      <div class="profile">
        <div class="swatch" style="background: {{color}}"></div>
        <div class="formats">
          <dl>
            <dd>{{hex}}</dd>
            <dd>{{rgb}}</dd>
            <dd>{{hsl}}</dd>
          </dl>
        </div>
      </div>
      <div class="color_inputs">
        <input type="text" class="hex_input" placeholder="#CCCCCC" />
        <input type="color" class="color_picker" />
      </div>
    """

  events:
    "input .color_picker": "onColorPickerClick"
    "keyup .hex_input": "onHexInput"

  initialize: ->
    @model.on 'change:color', @render, @

  render: ->
    color = @model.get('color')
    properties = _.extend {}, @model.toJSON(),
      hex: Panel.Lib.Color.toHexCSS color
      rgb: Panel.Lib.Color.toRgbCSS color
      hsl: Panel.Lib.Color.toHslCSS color
    @$el.html Mustache.render @template, properties
    this

  onColorPickerClick: (ev) ->
    ev.preventDefault()
    @model.set color: $(ev.currentTarget).val()

  onHexInput: (ev) ->
    ev.preventDefault()
    value = $(ev.currentTarget).val()
    @model.set color: value if value.length == 7
