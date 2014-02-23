class Panel.Views.SchemaView extends Backbone.View
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
      <div class="sixTone"></div>
    """

  render: ->
    @$el.html Mustache.render @template
    @renderColors()
    this

  renderColors: ->
    color = @model.get('color')
    for schema in ['complementary', 'triadic', 'analogous', 'sixTone', 'neutral', 'tetradic']
      view = new Panel.Views.ColorsView(colors: Panel.Lib.Color[schema](color))
      @$(".#{schema}").html view.render().el
