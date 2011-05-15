# 自定义集合中会用到
Product = Backbone.Model.extend
  name: 'product'

  addedTo: (collection) ->
    self = this
    collection.detect (model) ->
      model.attributes.product_id == self.id

# 商品选项
ProductOption = Backbone.Model.extend
  name: 'product_option'

# 商品款式
ProductVariant = Backbone.Model.extend
  name: 'product_variant'
