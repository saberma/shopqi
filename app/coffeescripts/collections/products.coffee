App.Collections.Products = Backbone.Collection.extend
  model: Product
  url: '/admin/products'

  initialize: ->
    _.bindAll this, 'addOne', 'updateCount'
    this.bind 'add', this.addOne
    this.bind 'all', this.updateCount

  addOne: (model, collection) ->
    new App.Views.CustomCollection.Product model: model

  updateCount: (model, collection) ->
    $('#collection-product-count').text(this.length)
