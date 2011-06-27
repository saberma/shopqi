App.Views.Customer.Show.Edit = Backbone.View.extend
  el: '#edit-customer-screen'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#edit-customer-screen-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
