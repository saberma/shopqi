App.Views.CustomCollection.Products = Backbone.View.extend
  initialize: ->
    this.render()

  el: '#products'

  render: ->
    _(this.collection.models).each (model) ->
      new App.Views.CustomCollection.Product model: model
