App.Views.Customer.Show.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #edit-customer-link": "toggleEdit"

  initialize: ->
    this.render()

  render: ->
    new App.Views.Customer.Show.Show model: @model
    new App.Views.Customer.Show.Order.Index model: @model
    new App.Views.Customer.Show.Edit model: @model

  toggleEdit: ->
    $('#edit-customer-screen').toggle()
    $('#show-customer-screen').toggle()
    false
