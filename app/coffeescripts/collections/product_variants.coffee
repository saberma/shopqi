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
    new App.Views.Product.Show.Variant.QuickSelect collection: collection
    new App.Views.ProductOption.Index collection: App.product.options

  # 所有款式的选项合集
  options: ->
    #return @data if @data
    @data = option1: [], option2: [], option3: []
    _(@models).each (model) =>
      i = 1
      _(@data).each (option, key) =>
        option.push model.attributes["option#{i++}"]
        @data[key] = _.uniq _.compact option
    @data
