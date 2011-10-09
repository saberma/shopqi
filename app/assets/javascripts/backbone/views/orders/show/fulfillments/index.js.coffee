App.Views.Order.Show.Fulfillment.Index = Backbone.View.extend
  el: '#mark-shipped'

  events:
    "click .btn": "save"
    "click .cancel": "cancel"
    "keyup #manual_tracking_number": "showCompany"

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
    attrs = 'shipped[]': line_item_ids, tracking_number: $('#manual_tracking_number').val(), tracking_company: $('#manual_tracking_company').val(), notify_customer: $('#notify_customer').is(':checked')
    $.post "/admin/orders/#{App.order.id}/fulfillments/set", attrs, (data) ->
      _(App.order.get('line_items')).chain().select (line_item) ->
        _(line_item_ids).include("#{line_item.id}")
      .each (line_item) ->
        line_item.fulfilled = true
        line_item.fulfillment_created_at = new Date()
      self.render()
      App.order.set fulfillment_status: data.fulfillment_status #修改订单的发货状态
    , 'json'
    self.cancel()
    false

  cancel: ->
    $('#mark-shipped').hide()
    $('#order-fulfillment').show()
    false

  showCompany: ->
    active = if $('#manual_tracking_number').val() then true else false
    $('#manual_tracking_company_area').toggle(active)
    $('#manual_tracking_company').attr 'disabled', !active
