App.Collections.Products = Backbone.Collection.extend
  model: Product
  url: '/admin/products'

  initialize: ->
    _.bindAll this, 'addOne', 'updateCount'
    this.bind 'add', this.addOne
    this.bind 'all', this.updateCount

  addOne: (model, collection) ->
    #新增成功!
    msg '\u65B0\u589E\u6210\u529F\u0021'
    new App.Views.CustomCollection.Product model: model

  updateCount: (model, collection) ->
    $('#collection-product-count').text(this.length)
