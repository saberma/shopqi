App.Collections.CustomCollectionProducts = Backbone.Collection.extend
  model: CustomCollectionProduct

  initialize: ->
    _.bindAll this, 'addOne', 'updateCount'
    this.bind 'add', this.addOne
    this.bind 'all', this.updateCount

  addOne: (model, collection) ->
    $.post "/admin/custom_collections/#{App.custom_collection_id}/add_product", product_id: model.id, ->
      new App.Views.CustomCollection.Product model: model

  updateCount: (model, collection) ->
    $('#collection-product-count').text(this.length)
