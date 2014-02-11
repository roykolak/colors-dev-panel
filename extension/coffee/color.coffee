ColorLib =
  lighten: (hex, decimal) ->
    Color(hex).lighten(decimal).hexString()

  darken: (hex, decimal) ->
    Color(hex).darken(decimal).hexString()

  saturate: (hex, decimal) ->
    Color(hex).saturate(decimal).hexString()

  range: ->
    out = []
    for i in [1..100]
      out.push i if i % 5 == 0
    out

  lightenRange: (hex, range = 20) ->
    out = (@lighten(hex, i / 100) for i in @range())
    out.splice(0, range)

  darkenRange: (hex, range = 20) ->
    out = (@darken(hex, i / 100) for i in @range())
    out.splice(0, range)

  saturateRange: (hex, range = 20) ->
    out = (@saturate(hex, i / 100) for i in @range())
    out.splice(0, range)

class ColorModel extends Backbone.Model
  initialize: ->
    @set
      rgb: Color(@get('hex')).rgbString()
      hsl: Color(@get('hex')).hslString()

class Colors extends Backbone.Collection
  model: ColorModel

class ColorsView extends Backbone.View
  template:
    """
      <ul class="colors">
        {{#colors}}
          <li data-color="{{hex}}" style="background: {{hex}}">
            <a href="#"></a>
          </li>
        {{/colors}}
      </ul>
    """

  initialize: ->
    @collection.on "add", @onColorAdd, @

  render: ->
    @$el.html Mustache.render @template,
      colors: @collection.toJSON().reverse()
    this

  onColorAdd: ->
    @render()

class ColorView extends Backbone.View
  template:
    """
      <div class="profile">
        <div class="swatch" style="background: {{hex}}"></div>
        <div class="formats">
          <dl>
            <dt>HEX</dt>
            <dd>{{hex}}</dd>
            <dt>RGB</dt>
            <dd>{{rgb}}</dd>
            <dt>HSL</dt>
            <dd>{{hsl}}</dd>
          </dl>
        </div>
      </div>
      <ul class="lighten colors">
        {{#lighten}}
          <li style="background: {{.}}">
            <a href="#" data-color="{{.}}" class="color"></a>
            <a href="#" data-color="{{.}}" title="copy to clipboard" class="fa fa-copy copy"></a>
          </li>
        {{/lighten}}
      </ul>
      <ul class="darken colors">
        {{#darken}}
          <li style="background: {{.}}">
            <a href="#" data-color="{{.}}" class="color"></a>
            <a href="#" data-color="{{.}}" title="copy to clipboard" class="fa fa-copy copy"></a>
          </li>
        {{/darken}}
      </ul>
      <ul class="saturate colors">
        {{#saturate}}
          <li style="background: {{.}}">
            <a href="#" data-color="{{.}}" class="color"></a>
            <a href="#" data-color="{{.}}" title="copy to clipboard" class="fa fa-copy copy"></a>
          </li>
        {{/saturate}}
      </ul>
    """

  events:
    'click .color': 'onColorClick'
    'click .copy': 'onCopyClick'

  initialize: ->
    @model.on 'change:hex', @onHexChange, @

  render: ->
    @$el.html Mustache.render @template,
      _.extend {}, @model.toJSON(),
        lighten: ColorLib.lightenRange(@model.get('hex'))
        darken: ColorLib.darkenRange(@model.get('hex'))
        saturate: ColorLib.saturateRange(@model.get('hex'))
    this

  onColorClick: (ev) ->
    ev.preventDefault()
    @model.set hex: $(ev.currentTarget).data('color')
    @collection.add hex: @model.get('hex')

  onCopyClick: (ev) ->
    ev.preventDefault()
    copy $(ev.currentTarget).data('color')

  onHexChange: ->
    @render()

$ ->
  recentColors = new Colors(hex: '#4573D5')
  new ColorsView(
    collection: recentColors
    el: $('#recent_colors')
  ).render()

  new ColorView(
    model: new ColorModel(hex: '#4573D5')
    collection: recentColors
    el: $('#color')
  ).render()
