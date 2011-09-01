App.Views.CustomCollection.Products = Backbone.View.extend
  initialize: ->
    @collection.view = this
    @render()

  el: '#products'

  render: ->
    $(@el).html ''
    @collection.each (model) ->
      new App.Views.CustomCollection.Product model: model
