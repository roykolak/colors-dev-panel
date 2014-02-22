class ColorModel extends Backbone.Model
  defaults:
    steps: 20
    color: '#4573D5'
    blendColor: '#D54545'

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
        <div class="swatch" style="background: {{hex}}"></div>
        <div class="formats">
          <dl>
            <dt>HEX</dt>
            <dd>{{hex}}</dd>
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
      <div class="colors"></div>
      <div class="range_controls">
        <input type="range" id="steps" min="3" max="1000" value="20">
        <span class="steps">{{steps}}</span>
      </div>
    """

  events:
    "input #steps": "onStepsChange"

  initialize: (options) ->
    @mode = options.mode

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    @renderColors()
    this

  renderColors: ->
    colorsView = new ColorsView(colors: ColorLib[@mode](@model.toJSON()))
    @$('.colors').html colorsView.render().el

  onStepsChange: (ev) ->
    $('.steps').text "#{$(ev.currentTarget).val()} steps"
    @model.set steps: $(ev.currentTarget).val()
    @renderColors()

class BlendView extends Backbone.View
  template:
    """
      <div class="colors"></div>
      <div class="range_controls">
        <input type="range" id="steps" min="3" max="1000" value="20">
        <span class="steps">{{steps}}</span>
        <input type="color" id="color_picker" value="{{blendColor}}">
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
    $('.steps').text "#{$(ev.currentTarget).val()} steps"
    @model.set steps: $(ev.currentTarget).val()

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

  initialize: (options) ->
    @colors = options.colors

  render: ->
    @$el.html Mustache.render @template, colors: @colors
    this

class SchemaView extends Backbone.View
  template:
    """
      <h4>Complementary</h4>
      <div class="complementary"></div>
      <h4>Triadic</h4>
      <div class="triadic"></div>
      <h4>Analogous</h4>
      <div class="analogous"></div>
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
    view = new ColorsView(colors: ColorLib.sixToneCW(color))
    @$('.sixToneCW').html view.render().el

$ ->
  model = new ColorModel(hex: '#4573D5')

  colorView = new ColorView model: model
  $('.side').html colorView.render().el

  tabView = new TabView model: model
  tabView.on 'selection', (selection) ->
    view = switch selection
      when 'schemas' then new SchemaView(model: @model)
      when 'blend' then new BlendView(model: @model)
      else new RangeView(model: @model, mode: selection)
    @update(view.render().el)
  , tabView

  $('.main').html tabView.render().el
