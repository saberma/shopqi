App.Views.Shipping.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #add-weight"             : "addWeight"
    "click #add-price"              : "addPrice"
    "click #cancel-weight"          : "cancelWeight"
    "click #cancel-price"           : "cancelPrice"
    "click #show-max-purchase a"    : "showMaxPurchase" # 显示价格的终止区间
    "blur #edit-max-purchase input" : "hideMaxPurchase" # 隐藏价格的终止区间

  initialize: ->
    new App.Views.Shipping.WeightBasedShippingRates.Index collection: App.weight_based_shipping_rates
    new App.Views.Shipping.PriceBasedShippingRates.Index collection: App.price_based_shipping_rates

  addWeight: ->
    $('#new-promotional-rate').hide()
    $('#new-standard-rate').show()
    $('#standard-rate-name-new').focus()
    false

  addPrice: ->
    $('#new-standard-rate').hide()
    $('#new-promotional-rate').show()
    $('#promotional-rate-name-new').focus()
    false

  cancelWeight: ->
    $('#new-standard-rate').hide()
    false

  cancelPrice: ->
    $('#new-promotional-rate').hide()
    false

  showMaxPurchase: ->
    $('#show-max-purchase').hide()
    $('#edit-max-purchase').show()
    $('#edit-max-purchase input').focus()
    false

  hideMaxPurchase: ->
    unless $('#edit-max-purchase input').val()
      $('#edit-max-purchase').hide()
      $('#show-max-purchase').show()
    false
