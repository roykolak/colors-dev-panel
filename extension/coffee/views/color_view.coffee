class Panel.Views.ColorView extends Backbone.View
  template:
    """
      <div class="profile">
        <div class="swatch" style="background: {{color}}"></div>
        <div class="formats">
          <dl>
            <dt>HEX</dt>
            <dd>{{color}}</dd>
            <dt>RGB</dt>
            <dd>{{rgb}}</dd>
            <dt>HSL</dt>
            <dd>{{hsl}}</dd>
          </dl>
        </div>
      </div>
    """

  initialize: ->
    @model.on 'change:color', @render, @

  render: ->
    color = @model.get('color')
    properties = _.extend {}, @model.toJSON(),
      rgb: Panel.Lib.Color.toRgbCSS color
      hsl: Panel.Lib.Color.toHslCSS color
    @$el.html Mustache.render @template, properties
    this

