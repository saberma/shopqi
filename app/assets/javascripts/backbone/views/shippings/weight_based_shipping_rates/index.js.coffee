App.Views.Shipping.WeightBasedShippingRates.Index = Backbone.View.extend

  initialize: ->
    @collection.view = this
    @render()

  render: ->
    self = this
    @collection.each (weight) -> new App.Views.Shipping.WeightBasedShippingRates.Show model: weight, collection: self.collection
