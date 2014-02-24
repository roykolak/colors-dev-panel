class Panel.Views.SitePaletteView extends Backbone.View
  template:
    """
      <ul class="palette">
        {{#sitePalette}}
          <li>
            <a href="#" class="site_color" data-color="{{.}}" style="background: {{.}}"></a>
          </li>
        {{/sitePalette}}
      </ul>
    """

  events:
    "click .site_color": "onSiteColorClick"

  initialize: ->
    @model.on 'change:sitePalette', @render, @

  render: ->
    @$el.html Mustache.render @template, @model.toJSON()
    this

  onSiteColorClick: (ev) ->
    ev.preventDefault()
    @model.set color: $(ev.currentTarget).data('color')
