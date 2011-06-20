App.Views.Order.Show.Transaction.Index = Backbone.View.extend
  el: '#order-status'

  events:
    "submit form": "save"

  initialize: ->
    self = this
    this.render()

  render: ->
    amounts = _(App.order.get('transactions')).map (transaction) -> transaction.amount
    amount_sum = _.reduce amounts, (memo, amount) ->
      memo + amount
    , 0
    template = Handlebars.compile $('#order-status-item').html()
    $(@el).html template payed: (App.order.get('transactions').length != 0 and amount_sum >= App.order.get('total_price'))

  save: ->
    self = this
    attrs = transaction: { kind: this.$("input[name='transaction[kind]']").val() }
    $.post "/admin/orders/#{App.order.id}/transactions", attrs, (data) ->
      log data
      App.order.get('transactions').push data.order_transaction
      self.render()
    false
