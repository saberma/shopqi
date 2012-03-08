App.Views.Shipping.WeightBasedShippingRates.Index = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    @collection.each (weight) -> new App.Views.Shipping.WeightBasedShippingRates.Show model: weight
