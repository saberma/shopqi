App.Views.Shipping.Index = Backbone.View.extend
  el: '#main'

  initialize: ->
    new App.Views.Shipping.WeightBasedShippingRates.Index collection: App.weight_based_shipping_rates
    new App.Views.Shipping.PriceBasedShippingRates.Index collection: App.price_based_shipping_rates
