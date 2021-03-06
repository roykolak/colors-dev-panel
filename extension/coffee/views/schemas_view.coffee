class Panel.Views.SchemaView extends Backbone.View
  template:
    """
      <dl>
        <dt>Complementary</dt>
        <dd class="complementary"></dd>
        <dt>Triadic</dt>
        <dd class="triadic"></dd>
        <dt>Analogous</dt>
        <dd class="analogous"></dd>
        <dt>Neutral</dt>
        <dd class="neutral"></dd>
        <dt>Tetradic</dt>
        <dd class="tetradic"></dd>
      </dl>
    """

  initialize: ->
    @model.on 'change:color', @render, @

  render: ->
    @$el.html Mustache.render @template
    @renderColors()
    this

  renderColors: ->
    color = @model.get('color')
    for schema in ['complementary', 'triadic', 'analogous', 'neutral', 'tetradic']
      view = new Panel.Views.ColorsView
        model: @model
        colors: Panel.Lib.Color[schema](color)

      view.on 'select', (color) =>
        @model.set color: color

      @$(".#{schema}").html view.render().el
