App.Collections.ProductOptions = Backbone.Collection.extend
  model: ProductOption

  initialize: ->
    _.bindAll this, 'addOne', 'removeOne', 'showBtn'
    this.bind 'add', this.addOne
    this.bind 'remove', this.removeOne
    # 超过3个则隐藏[新增按钮]
    this.bind 'all', this.showBtn

  addOne: (model, collection) ->
    new App.Views.ProductOption.Edit model: model

  removeOne: (model, collection) ->
    model.view.remove()

  showBtn: (model, collection) ->
    if this.length >= 3
      $('#add-option-bt').hide()
    else
      $('#add-option-bt').show()
