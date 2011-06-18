App.Views.Order.Show.Fulfillment.Panel = Backbone.View.extend
  el: '#unshipped-goods'

  events:
    "click .btn": "show"

  initialize: ->
    self = this
    this.render()
    App.order.bind 'change:fulfillment_status', -> self.render()

  render: ->
    template = Handlebars.compile $('#unshipped-goods-item').html()
    fulfilled = App.order.get('fulfillment_status') == 'fulfilled'
    attr = { fulfilled: fulfilled }
    $(@el).html template attr

  show: ->
    $('#mark-shipped').show()
    $('#order-fulfillment').hide()
    false
