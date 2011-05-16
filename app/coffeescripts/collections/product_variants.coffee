App.Collections.ProductVariants = Backbone.Collection.extend
  model: ProductVariant

  url: ->
    "/admin/products/#{App.product.id}/variants"

  initialize: ->
    _.bindAll this, 'addOne'
    this.bind 'add', this.addOne

  addOne: (model, collection) ->
    #新增成功!
    msg '\u65B0\u589E\u6210\u529F\u0021'
    $('#new-variant-link').show()
    $('#new-variant').hide()
    new App.Views.Product.Show.Variant.Show model: model
