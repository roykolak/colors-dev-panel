class Panel.Views.ColorView extends Backbone.View
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

