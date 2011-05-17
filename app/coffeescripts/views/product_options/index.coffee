App.Views.ProductOption.Index = Backbone.View.extend
  el: '#product-properties'

  events:
    "click .add-option": "addOption"

  initialize: ->
    _.bindAll this, 'addOption'
    self = this
    # 商品款式
    if @collection.length > 0
      self.render()
    $('#enable-options').change ->
      if $(this).attr('checked')
        if self.collection.length <= 0
          self.collection.add new ProductOption()
        $('#create-options-frame').show()
      else
        self.collection.each (model) ->
          model.view.remove()
        self.collection.refresh []
        $('#create-options-frame').hide()
    .change()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.ProductOption.Edit model: model
      new App.Views.ProductOption.Show model: model
    @collection.showBtn()

  addOption: ->
    @collection.add new ProductOption()
    false
