App.Views.ProductOption.Index = Backbone.View.extend
  el: '#product-properties'

  events:
    "click .add-option": "addOption"

  initialize: ->
    _.bindAll this, 'addOption'
    self = this
    # 商品款式
    if App.product_options.length > 0
      self.render()
    $('#enable-options').change ->
      if $(this).attr('checked')
        if App.product_options.length <= 0
          App.product_options.add new ProductOption()
        $('#create-options-frame').show()
      else
        App.product_options.each (model) ->
          model.view.remove()
        App.product_options.refresh []
        $('#create-options-frame').hide()
    .change()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.ProductOption.Edit model: model
    @collection.showBtn()

  addOption: ->
    App.product_options.add new ProductOption()
    false
