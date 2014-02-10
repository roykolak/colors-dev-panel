class ColorModel extends Backbone.Model
  initialize: ->
    @set
      rgb: Color(@get('hex')).rgbString()
      hsl: Color(@get('hex')).hslString()

  lightenRange: (range = 20) ->
    for i in [1..range]
      i = "0#{i}" if i.toString().length == 1
      Color(@get('hex')).lighten("0.#{i}").hexString()

  darkenRange: (range = 20) ->
    for i in [1..range]
      i = "0#{i}" if i.toString().length == 1
      Color(@get('hex')).darken("0.#{i}").hexString()

  saturateRange: (range = 20) ->
    for i in [1..range]
      i = "0#{i}" if i.toString().length == 1
      Color(@get('hex')).saturate("0.#{i}").hexString()

class ColorView extends Backbone.View
  template:
    """
      <div class="profile">
        <div class="swatch" style="background: {{hex}}"></div>
        <dl class="formats">
          <dt>HEX</dt>
          <dd>{{hex}}</dd>
          <dt>RGB</dt>
          <dd>{{rgb}}</dd>
          <dt>HSL</dt>
          <dd>{{hsl}}</dd>
        </dl>
      </div>
      <ul class="lighten">
        {{#lighten}}
          <li data-color="{{.}}" style="background: {{.}}">
            <a href="#"></a>
          </li>
        {{/lighten}}
      </ul>
      <ul class="darken">
        {{#darken}}
          <li data-color="{{.}}" style="background: {{.}}">
            <a href="#"></a>
          </li>
        {{/darken}}
      </ul>
      <ul class="saturate">
        {{#saturate}}
          <li data-color="{{.}}" style="background: {{.}}">
            <a href="#"></a>
          </li>
        {{/saturate}}
      </ul>
    """

  render: ->
    @$el.html Mustache.render @template,
      _.extend {}, @model.toJSON(),
        lighten: @model.lightenRange()
        darken: @model.darkenRange()
        saturate: @model.saturateRange()
    this

$ ->
  new ColorView(
    model: new ColorModel(hex: '#4573D5')
    el: $('#color')
  ).render()
