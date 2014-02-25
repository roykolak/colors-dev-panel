class Panel.Views.ColorControlsView extends Backbone.View
  template:
    """
      <div class="color_inputs">
        <input type="text" class="hex_input" placeholder="#CCCCCC" />
        <input type="color" class="color_picker" />
      </div>
    """

  events:
    "input .color_picker": "onColorPickerClick"
    "keyup .hex_input": "onHexInput"

  initialize: ->
    @model.on 'change:color', @updateHaxInput, @

  render: ->
    @$el.html Mustache.render @template
    this

  onColorPickerClick: (ev) ->
    @model.set
      color: $(ev.currentTarget).val()

  onHexInput: (ev) ->
    ev.preventDefault()
    value = $(ev.currentTarget).val()
    if value.length == 7
      @model.set color: value

  updateHaxInput: ->
    @$('.hex_input').val Panel.Lib.Color.toHexCSS(@model.get('color'))
