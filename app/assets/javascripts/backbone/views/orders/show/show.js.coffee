App.Views.Order.Show.Show = Backbone.View.extend
  el: '#main' #注意:其他子视图不能再绑定#main，否则events会被覆盖而不生效

  events:
    'click #note': 'showNote'
    'click #cancel-order': 'showCancel'

  initialize: ->
    @render()

  render: ->
    new App.Views.Order.Show.Transaction.Index
    new App.Views.Order.Show.Fulfillment.Panel
    new App.Views.Order.Show.Fulfillment.Index
    new App.Views.Order.Show.LineItem.Index model: App.order
    new App.Views.Order.Show.History.Index
    new App.Views.Order.Show.Note
    new App.Views.Order.Show.OtherOrders model: App.order

  showNote: ->
    $('#order-note').hide()
    $('#note-form').show()
    false

  showCancel: ->
    template = Handlebars.compile $('#cancel-order-item').html()
    $.blockUI message: template()
    false
