App.Views.CustomCollection.Products = Backbone.View.extend
  initialize: ->
    this.collection.view = this
    this.render()

  el: '#products'

  render: ->
    $(this.el).html('')
    _(this.collection.models).each (model) ->
      new App.Views.CustomCollection.Product model: model
