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

  render: ->
    @$el.html Mustache.render @template
    this

  onColorPickerClick: (ev) ->
    @model.set
      color: $(ev.currentTarget).val()
      rangeStart: $(ev.currentTarget).val()
      syncColor: null

  onHexInput: (ev) ->
    ev.preventDefault()
    value = $(ev.currentTarget).val()
    if value.length == 7
      @model.set
        color: value
        rangeStart: value
        syncColor: null
