App.Views.Theme.Themes.Show = Backbone.View.extend
  tagName: 'li'
  tagClass: 'clearfix'

  initialize: ->
    @render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = _.clone @model.attributes
    attrs['is_main'] = @model.get('role') is 'main'
    attrs['is_published'] = @model.get('role') isnt 'unpublished'
    $(@el).html template attrs
    parent = $(@options.parent)
    parent.show()
    $('ul', parent).append @el
