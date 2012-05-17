App.Views.Order.Show.OtherOrders = Backbone.View.extend
  el: '#other-orders-box'

  initialize: ->
    other_orders =  @model.get('other_orders')
    @render() unless _.isEmpty(other_orders)

  render: ->
    $(@el).show()
    template = Handlebars.compile $('#other-orders-item').html()
    _.each @model.get('other_orders'), (order) ->
      order = order['order']
      order['created_at'] = Utils.Date.to_s(order['created_at'], 'MM-dd HH:mm')
      $('#other-orders').append template order

    value = App.order.get('note')
    if value
      $('#note-body').text value
      $('#order_note').val value
      $('#order-note').show()

  save: ->
    self = this
    value = $('#order_note').val()
    attr = { order: { note: value }, _method: 'put' }
    $.post App.order.url(), attr, ->
      App.order.set note: value
      self.cancel()
    false

  cancel: ->
    $('#note-form').hide()
    this.render()
    false
