App.Views.Customer.Show.Order.Index = Backbone.View.extend
  el: '#show-customer-screen'

  initialize: ->
    self = this
    @collection = new App.Collections.Orders @model.get('orders')
    this.render()

  render: ->
    self = this
    # 统计信息
    template = Handlebars.compile $('#customer-facts-item').html()
    attrs = _.clone @model.attributes
    order = @model.get('order')
    attrs['first_order_date'] = if order? then Utils.Date.formatDate(order.created_at) else '-'
    $('#customer-facts').html template attrs
    # 订单列表
    @collection.each (model) -> new App.Views.Customer.Show.Order.Show model: model
