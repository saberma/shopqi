App.Views.Theme.Show.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    self = this
    this.render()
    $("a.fancy-box, a.login").fancybox()

  render: ->
    template = Handlebars.compile $('#overview-item').html()
    attrs = @model.clone_attributes()
    $('#overview').html template attrs
    template = Handlebars.compile $('#screenshots-item').html()
    $('#screenshots').html template id: @model.id
    new App.Views.Theme.Show.Style
    new App.Views.Theme.Show.Other
