App.Models.WeightBasedShippingRate = Backbone.Model.extend
  name: 'weight_based_shipping_rate'

App.Collections.WeightBasedShippingRates = Backbone.Collection.extend
  model: App.Models.WeightBasedShippingRate
  url: '/admin/weight_based_shipping_rates'

App.Models.PriceBasedShippingRate = Backbone.Model.extend
  name: 'price_based_shipping_rate'

App.Collections.PriceBasedShippingRates = Backbone.Collection.extend
  model: App.Models.PriceBasedShippingRate
  url: '/admin/price_based_shipping_rates'
