App.Views.Shipping.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #add-weight"             : "addWeight"
    "click #add-price"              : "addPrice"

  initialize: ->
    new App.Views.Shipping.WeightBasedShippingRates.Index collection: App.weight_based_shipping_rates
    new App.Views.Shipping.PriceBasedShippingRates.Index collection: App.price_based_shipping_rates
    new App.Views.Shipping.WeightBasedShippingRates.New collection: App.weight_based_shipping_rates
    new App.Views.Shipping.PriceBasedShippingRates.New collection: App.price_based_shipping_rates

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
