App.Views.Customer.Show.Order.Index = Backbone.View.extend
  el: '#show-customer-screen'

  initialize: ->
    self = this
    @collection = new App.Collections.Orders @model.get('orders')
    this.render()

  render: ->
    self = this
    template = Handlebars.compile $('#customer-facts-item').html()
    $('#customer-facts').html template @model.attributes
    @collection.each (model) -> new App.Views.Customer.Show.Order.Show model: model
