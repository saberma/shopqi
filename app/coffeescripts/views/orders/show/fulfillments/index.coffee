App.Views.Order.Show.Fulfillment.Index = Backbone.View.extend
  el: '#unshipped-goods'

  events:
    "click .btn": "show"

  initialize: ->
    _.bindAll this, 'show'
    self = this

  show: ->
    $('#mark-shipped').show()
    false
