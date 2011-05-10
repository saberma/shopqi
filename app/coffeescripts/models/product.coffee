Product = Backbone.Model.extend
  name: 'product'

  addedTo: (collection) ->
    self = this
    collection.detect (model) ->
      model.attributes.product_id == self.id

ProductOption = Backbone.Model.extend
  name: 'product_option'
