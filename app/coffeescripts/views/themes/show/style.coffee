App.Views.Theme.Show.Style = Backbone.View.extend
  el: '#styles'

  initialize: ->
    _(App.styles_json).each (style) -> style['is_current'] = (style.id is App.theme.id)
    this.render()

  render: ->
    template = Handlebars.compile $('#styles-item').html()
    $(@el).html template styles: App.styles_json, current_id: App.theme.id
