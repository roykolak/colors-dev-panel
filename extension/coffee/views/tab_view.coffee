class Panel.Views.TabView extends Backbone.View
  template:
    """
      <div class="tab_header">
        <a href="#" class="collapse"></a>
        <a href="#" class="expand" style="display: none;"></a>
        <ul class="tabs">
          <li class="selected" data-tab="lighten">
            <a href="#">Lighten</a>
          </li>
          <li data-tab="darken">
            <a href="#">Darken</a>
          </li>
          <li data-tab="saturate">
            <a href="#">Saturate</a>
          </li>
          <li data-tab="desaturate">
            <a href="#">Desaturate</a>
          </li>
          <li data-tab="blend">
            <a href="#">Blend</a>
          </li>
          <li data-tab="schemas">
            <a href="#">Schemas</a>
          </li>
        </ul>
      </div>
      <div id="tab_content" style="overflow: scroll"></div>
    """

  events:
    "click ul.tabs > li": "onItemClick"
    "click .collapse": "onCollapseClick"
    "click .expand": "onExpandClick"

  render: ->
    @$el.html Mustache.render @template
    @trigger 'selection', 'lighten'
    this

  onItemClick: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    @$('.selected').removeClass('selected')
    $el.addClass('selected')
    @trigger 'selection', $el.data('tab')

  update: ($el) ->
    @$('#tab_content').html $el

  onCollapseClick: (ev) ->
    ev.preventDefault()
    @$('.expand').show()
    @$('.collapse').hide()
    $('.middle').addClass('collapse')

  onExpandClick: (ev) ->
    ev.preventDefault()
    @$('.expand').hide()
    @$('.collapse').show()
    $('.middle').removeClass('collapse')
