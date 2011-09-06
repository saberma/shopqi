App.Views.Theme.Themes.Index.Show = Backbone.View.extend
  tagName: 'li'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = @model.clone_attributes()
    $(@el).attr('data-id', "theme-#{@model.id}").html template attrs
