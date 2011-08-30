App.Collections.CustomCollectionProducts = Backbone.Collection.extend
  model: CustomCollectionProduct
  url: ->
    "/admin/custom_collections/#{App.custom_collection_id}/products"

  initialize: ->
    _.bindAll this, 'addOne', 'updateCount', 'rerender'
    this.bind 'add', this.addOne
    this.bind 'all', this.updateCount
    this.bind 'refresh', this.rerender

  addOne: (model, collection) ->
    new App.Views.CustomCollection.Product model: model

  updateCount: (model, collection) ->
    $('#collection-product-count').text(this.length)

  rerender: (model, collection) ->
    if this.view
      this.view.render()
