App.Views.Order.Show.Show = Backbone.View.extend
  el: '#main'

  events:
    "click #unshipped-goods .btn": "showFulfilment"

  initialize: ->
    this.render()

  render: ->
    new App.Views.Order.Show.Fulfillment.Index

  showFulfilment: ->
    $('#mark-shipped').show()
    $('#order-fulfillment').hide()
    false
