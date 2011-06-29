App.Views.Customer.Show.Note = Backbone.View.extend
  el: '#customer-note'

  initialize: ->
    self = this
    this.render()
    @model.bind 'change:note', -> self.render()

  render: ->
    template = Handlebars.compile $('#customer-note-item').html()
    $(@el).html template @model.attributes
