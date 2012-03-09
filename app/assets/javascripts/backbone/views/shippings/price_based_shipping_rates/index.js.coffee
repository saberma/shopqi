App.Views.Shipping.PriceBasedShippingRates.Index = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    self = this
    @collection.each (price) -> new App.Views.Shipping.PriceBasedShippingRates.Show model: price, collection: self.collection
