App.Views.Order.Show.Fulfillment.Index = Backbone.View.extend
  el: '#mark-shipped'

  events:
    "click .btn": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    this.render()
    _(App.order.get('line_items')).each (line_item) ->
      new App.Views.Order.Show.Fulfillment.Edit line_item: line_item

  save: ->
    this.cancel()
    false

  cancel: ->
    $('#mark-shipped').hide()
    $('#order-fulfillment').show()
    false
