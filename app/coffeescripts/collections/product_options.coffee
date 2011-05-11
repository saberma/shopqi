App.Collections.ProductOptions = Backbone.Collection.extend
  model: ProductOption

  initialize: ->
    this.bind 'add', this.addOne
    this.bind 'remove', this.removeOne
    # 超过3个则隐藏[新增按钮]
    this.bind 'all', (method, model, collection) ->
      if collection.length >= 3
        $('#add-option-bt').hide()
      else
        $('#add-option-bt').show()

  addOne: (model, collection) ->
    new App.Views.ProductOption.Edit model: model

  removeOne: (model, collection) ->
    model.view.remove()
