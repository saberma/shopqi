App.Collections.ProductOptions = Backbone.Collection.extend
  model: ProductOption

  initialize: ->
    this.bind 'add', this.addOne
    this.bind 'remove', this.removeOne

  addOne: (model, collection) ->
    new App.Views.ProductOption.Edit model: model

  removeOne: (model, collection) ->
    model.view.remove()
