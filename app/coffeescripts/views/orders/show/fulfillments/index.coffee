App.Views.Order.Show.Fulfillment.Index = Backbone.View.extend
  el: '#mark-shipped'

  events:
    "click .btn": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    this.render()

  render: ->
    $('#mark-shipped table').html('')
    _(App.order.get('line_items')).each (line_item) ->
      new App.Views.Order.Show.Fulfillment.Edit line_item: line_item

  save: ->
    self = this
    line_item_ids = _.map self.$('.fulfill:checked'), (checkbox) -> checkbox.value
    $.post "/admin/orders/#{App.order.id}/fulfillments/set", 'shipped[]': line_item_ids, (data) ->
      App.order.set fulfillment_status: data.fulfillment_status #修改订单的发货状态
      _(App.order.get('line_items')).each (line_item) -> line_item.fulfilled = true
      self.render()
    , 'json'
    self.cancel()
    false

  cancel: ->
    $('#mark-shipped').hide()
    $('#order-fulfillment').show()
    false
