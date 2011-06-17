App.Views.Order.Show.Show = Backbone.View.extend
  el: '#main'

  initialize: ->
    this.render()

  render: ->
    new App.Views.Order.Show.Fulfillment.Panel
    new App.Views.Order.Show.Fulfillment.Index
