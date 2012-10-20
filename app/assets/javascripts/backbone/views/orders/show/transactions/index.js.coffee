App.Views.Order.Show.Transaction.Index = Backbone.View.extend
  el: '#order-status'

  events:
    "submit form": "save"

  initialize: ->
    self = this
    this.render()

  render: ->
    order = App.order
    amounts = _(order.get('transactions')).map (transaction) -> transaction.amount
    amount_sum = _.reduce amounts, (memo, amount) ->
      memo + amount
    , 0
    template = Handlebars.compile $('#order-status-item').html()
    financial_status = order.get('financial_status')
    payed = financial_status is 'paid' or (order.get('transactions').length != 0 and amount_sum >= order.get('total_price'))
    refunded = financial_status is 'refunded'
    $(@el).html template payed: payed, refunded: refunded, gateway: order.get('gateway')

  save: ->
    self = this
    attrs = transaction: { kind: this.$("input[name='transaction[kind]']").val() }
    $.post "/admin/orders/#{App.order.id}/transactions", attrs, (data) ->
      App.order.get('transactions').push data.order_transaction
      self.render()
    false
