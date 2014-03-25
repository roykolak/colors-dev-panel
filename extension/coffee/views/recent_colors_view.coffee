class Panel.Views.RecentColorsView extends Backbone.View
  template:
    """
      <ul class="recent_colors">
        {{#colors}}
          <li style="background: {{color}}" data-color="{{color}}" class="color"></li>
        {{/colors}}
      </ul>
    """

  events:
    "click .color": "onColorClick"

  initialize: ->
    @collection.on 'add', @onColorAdd, @

  render: ->
    properties = colors: @collection.toJSON().reverse().splice(0, 8)
    @$el.html Mustache.render @template, properties
    this

  onColorClick: (ev) ->
    ev.preventDefault()
    value = $(ev.currentTarget).data('color')
    @model.set color: value

  onColorAdd: ->
    @render()
