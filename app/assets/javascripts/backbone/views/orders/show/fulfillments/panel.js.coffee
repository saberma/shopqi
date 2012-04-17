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
    unshipped_line_items = _(App.order.get('line_items')).select (line_item) -> !line_item.fulfilled
    attr = fulfilled: fulfilled, unshipped_line_items: unshipped_line_items
    $(@el).html template attr

  show: ->
    $('#mark-shipped').show()
    $('#order-fulfillment').hide()
    $('#manual_tracking_number').focus()
    false
