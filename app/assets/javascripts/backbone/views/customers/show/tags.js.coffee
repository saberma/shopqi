App.Views.Customer.Show.Tags = Backbone.View.extend
  el: '#customer-tags'

  initialize: ->
    self = this
    this.render()
    @model.bind 'change:tags_text', -> self.render()

  render: ->
    template = Handlebars.compile $('#customer-tags-item').html()
    $(@el).html template @model.attributes
