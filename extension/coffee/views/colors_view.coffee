class Panel.Views.ColorsView extends Backbone.View
  template:
    """
      <ol class="colors {{#syncColor}}syncing{{/syncColor}}">
        {{#colors}}
          <li style="background: {{.}}" data-color="{{.}}" draggable="true">
            <a href="#" data-color="{{.}}" title="copy to clipboard" class="fa fa-copy copy"></a>
          </li>
        {{/colors}}
      </ol>
    """

  events:
    "click .copy": "onCopyClicked"
    "click li": "onColorClicked"

  initialize: (options) ->
    @colors = options.colors
    @draggable = options.draggable || true
    @droppable = options.droppable || false

  render: ->
    properties = _.extend {}, @model.toJSON(), colors: @colors
    @$el.html Mustache.render @template, properties

    if @draggable
      handleDragStart = (ev) =>
        ev.stopPropagation()
        $el = $(ev.currentTarget)
        $el.addClass 'dragging'
        ev.dataTransfer.setData 'application/json', JSON.stringify(color: $el.data('color'))

      handleDragEnd = (ev) =>
        $el = $(ev.currentTarget)
        $el.removeClass 'dragging'

      @$('li').each (i, el) ->
        el.addEventListener('dragstart', handleDragStart, false)
        el.addEventListener('dragend', handleDragEnd, false)

    if @droppable
      @$('li').each (i, $el) =>
        $el.addEventListener('dragenter', (ev) ->
          $(ev.currentTarget).addClass 'over'
        , false)

        $el.addEventListener('dragleave', (ev) ->
          $(ev.currentTarget).removeClass 'over'
        , false)

        $el.addEventListener('dragover', (ev) ->
          ev.preventDefault()
          ev.dataTransfer.effect = 'move'
        , false)

        $el.addEventListener('drop', (ev) =>
          $el = $(ev.currentTarget)
          ev.stopPropagation()
          draggedData = JSON.parse ev.dataTransfer.getData('application/json')
          @model.set
            syncColor: $el.data('color')
            color: draggedData.color
            rangeStart: draggedData.color
        , false)

    this

  onCopyClicked: (ev) ->
    ev.stopImmediatePropagation()
    $el = $(ev.currentTarget)

    color = switch @model.get('copyFormat')
      when 'rgb' then Panel.Lib.Color.toRgbCSS($el.data('color'))
      when 'hsl' then Panel.Lib.Color.toHslCSS($el.data('color'))
      when 'hex' then Panel.Lib.Color.toHexCSS($el.data('color'))

    copyDiv = document.createElement('div')
    copyDiv.contentEditable = true
    document.body.appendChild(copyDiv)
    copyDiv.innerHTML = color
    copyDiv.unselectable = "off"
    copyDiv.focus()

    document.execCommand('SelectAll')
    document.execCommand("Copy", false, null)

    document.body.removeChild(copyDiv)
    $el.parent().addClass('flash_once animated')

  onColorClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    event = if $el.hasClass 'selected' then 'unselect' else 'select'
    @trigger event, $el.data('color'), $el
