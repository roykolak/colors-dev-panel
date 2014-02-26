class Panel.Views.ColorControlsView extends Backbone.View
  template:
    """
      <div class="color_inputs">
        <input type="text" class="hex_input" placeholder="#CCCCCC" value="{{color}}"/>
        <input type="color" class="color_picker" />
      </div>
    """

  events:
    "input .color_picker": "onColorPickerClick"
    "keyup .hex_input": "onHexInput"

  initialize: ->
    @model.on 'change:color', @updateHaxInput, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    this

  onColorPickerClick: (ev) ->
    value = $(ev.currentTarget).val()
    @model.set color: value
    @model.set rangeStart: value unless @model.get('syncColor')

  onHexInput: (ev) ->
    ev.preventDefault()
    value = $(ev.currentTarget).val()
    if value.length == 7
      @model.set color: value
      @model.set rangeStart: value unless @model.get('syncColor')

  updateHaxInput: ->
    @$('.hex_input').val Panel.Lib.Color.toHexCSS(@model.get('color'))
