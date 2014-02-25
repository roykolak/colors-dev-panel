class Panel.Views.ColorsView extends Backbone.View
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
    "click .color": "onColorClicked"

  initialize: (options) ->
    @colors = options.colors

  render: ->
    properties = _.extend {}, @model.toJSON(), colors: @colors
    @$el.html Mustache.render @template, properties
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

  onColorClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    event = if $el.hasClass 'selected' then 'unselect' else 'select'
    @trigger event, $el.data('color'), $el
