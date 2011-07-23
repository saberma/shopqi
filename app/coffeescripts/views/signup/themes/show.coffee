App.Views.Signup.Theme.Show = Backbone.View.extend
  tagName: 'li'
  className: 'theme'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = @model.attributes
    $(@el).html template attrs
