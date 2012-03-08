App.Views.Shipping.PriceBasedShippingRates.Index = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    @collection.each (price) -> new App.Views.Shipping.PriceBasedShippingRates.Show model: price
