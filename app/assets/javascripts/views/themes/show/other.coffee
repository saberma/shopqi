App.Views.Theme.Show.Other = Backbone.View.extend
  el: '#more-designer'

  initialize: ->
    @collection = App.others_json
    this.render()

  render: ->
    template = Handlebars.compile $('#more-designer-item').html()
    $(@el).html template author: App.theme.get('author')
    template = Handlebars.compile $('#theme-item').html()
    @collection.each (model) -> $('#themes').append template model.clone_attributes()
