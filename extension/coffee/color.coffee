class TabView extends Backbone.View
  template:
    """
      <ul class="tabs">
        <li class="selected" data-tab="lighten">
          <a href="#">Lighten</a>
        </li>
        <li data-tab="darken">
          <a href="#">Darken</a>
        </li>
        <li data-tab="saturate">
          <a href="#">Saturate</a>
        </li>
        <li data-tab="desaturate">
          <a href="#">Desaturate</a>
        </li>
        <li data-tab="blend">
          <a href="#">Blend</a>
        </li>
        <li data-tab="schemas">
          <a href="#">Schemas</a>
        </li>
      </ul>
      <div id="tab_content" style="overflow: scroll"></div>
    """

  events:
    "click li": "onItemClick"

  render: ->
    @$el.html Mustache.render @template
    @trigger 'selection', 'lighten'
    this

  onItemClick: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    @$('.selected').removeClass('selected')
    $el.addClass('selected')
    @trigger 'selection', $el.data('tab')

  update: ($el) ->
    @$('#tab_content').html $el

class ColorView extends Backbone.View
  template:
    """
      <div class="profile">
        <div class="swatch" style="background: {{color}}"></div>
        <div class="formats">
          <dl>
            <dt>HEX</dt>
            <dd>{{color}}</dd>
          </dl>
        </div>
      </div>
    """

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    this

class RangeView extends Backbone.View
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
    colorsView = new ColorsView(colors: ColorLib[@mode](@model.toJSON()))
    @$('.range_colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    $('.steps').text steps
    @model.set steps: steps

class BlendView extends Backbone.View
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
    colorsView = new ColorsView(colors: ColorLib.blend(@model.toJSON()))
    @$('.colors').html colorsView.render().el

  onStepsChange: (ev) ->
    steps = parseInt($(ev.currentTarget).val(), 10)
    $('.steps').text steps
    @model.set steps: steps

  onBlendColorChange: (ev) ->
    @model.set blendColor: $(ev.currentTarget).val()

class ColorsView extends Backbone.View
  template:
    """
      <ol class="colors">
        {{#colors}}
          <li style="background: {{.}}">
            <a href="#" data-color="{{.}}" class="color"></a>
            <a href="#" data-color="{{.}}" title="copy to clipboard" class="fa fa-copy copy"></a>
          </li>
        {{/colors}}
      </ol>
    """

  events:
    "click .copy": "onCopyClicked"

  initialize: (options) ->
    @colors = options.colors

  render: ->
    @$el.html Mustache.render @template, colors: @colors
    this

  onCopyClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    copyDiv = document.createElement('div')
    copyDiv.contentEditable = true
    document.body.appendChild(copyDiv)
    copyDiv.innerHTML = $el.data('color')
    copyDiv.unselectable = "off"
    copyDiv.focus()
    document.execCommand('SelectAll')
    document.execCommand("Copy", false, null)
    document.body.removeChild(copyDiv)

class SchemaView extends Backbone.View
  template:
    """
      <h4>Complementary</h4>
      <div class="complementary"></div>
      <h4>Triadic</h4>
      <div class="triadic"></div>
      <h4>Analogous</h4>
      <div class="analogous"></div>
      <h4>Neutral</h4>
      <div class="neutral"></div>
      <h4>Tetradic</h4>
      <div class="tetradic"></div>
      <h4>SixTone</h4>
      <div class="six_tone"></div>
    """

  render: ->
    @$el.html Mustache.render @template
    @renderColors()
    this

  renderColors: ->
    color = @model.get('color')
    view = new ColorsView(colors: ColorLib.complementary(color))
    @$('.complementary').html view.render().el
    view = new ColorsView(colors: ColorLib.triadic(color))
    @$('.triadic').html view.render().el
    view = new ColorsView(colors: ColorLib.analogous(color))
    @$('.analogous').html view.render().el
    view = new ColorsView(colors: ColorLib.sixTone(color))
    @$('.six_tone').html view.render().el
    view = new ColorsView(colors: ColorLib.neutral(color))
    @$('.neutral').html view.render().el
    view = new ColorsView(colors: ColorLib.tetradic(color))
    @$('.tetradic').html view.render().el

$ ->
  model = new Backbone.Model
    color: '#4573D5'
    steps: 40
    blendColor: '#D54545'

  colorView = new ColorView model: model
  $('.side').html colorView.render().el

  tabView = new TabView model: model
  tabView.on 'selection', (selection) ->
    view = switch selection
      when 'schemas'
        new SchemaView(model: @model)
      when 'blend'
        new BlendView(model: @model)
      else
        new RangeView(model: @model, mode: selection)
    @update(view.render().el)
  , tabView

  $('.main').html tabView.render().el
