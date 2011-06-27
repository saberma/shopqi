App.Views.Customer.Show.Index = Backbone.View.extend
  el: '#main'

  initialize: ->
    this.render()

  render: ->
    new App.Views.Customer.Show.Show model: @model
    new App.Views.Customer.Show.Order.Index model: @model
