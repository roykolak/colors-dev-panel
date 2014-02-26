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
    @trigger 'selection', @model.get('tab')
    @model.on 'change:pageColorsCollapsed', @collapse, @
    @model.on 'change:tab', @loadTab, @
    this

  onItemClick: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    @model.set tab: $el.data('tab')
    @loadTab()

  loadTab: ->
    @$('.selected').removeClass('selected')
    @$("[data-tab='#{@model.get('tab')}']").addClass('selected')
    @trigger 'selection', @model.get('tab')

  update: ($el) ->
    @$('#tab_content').html $el

  onCollapseClick: (ev) ->
    ev.preventDefault()
    @model.unset 'syncColor'
    @model.set pageColorsCollapsed: true
    @collapse()

  collapse: ->
    @$('.expand').show()
    @$('.collapse').hide()
    $('body').addClass('collapsed_page_colors')

  onExpandClick: (ev) ->
    ev.preventDefault()
    @model.set pageColorsCollapsed: false
    @expand()

  expand: ->
    @$('.expand').hide()
    @$('.collapse').show()
    $('body').removeClass('collapsed_page_colors')
