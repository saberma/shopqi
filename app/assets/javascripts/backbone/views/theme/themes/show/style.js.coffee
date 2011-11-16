App.Views.Theme.Themes.Show.Style = Backbone.View.extend
  el: '#styles'

  initialize: ->
    if App.styles_json.length > 1
      _(App.styles_json).each (style) ->
        style['is_current'] = (style.id is App.theme.id)
        style['has_shop'] = (style.shop isnt '')
      this.render()

  render: ->
    template = Handlebars.compile $('#styles-item').html()
    $(@el).html template styles: App.styles_json, style_size: App.styles_json.length
