App.Collections.AvailableProducts = Backbone.Collection.extend
  model: Product
  url: '/admin/available_products'

  initialize: ->
    self = this
    this.bind 'refresh', ->
      _(self.models).each (model) ->
        new App.Views.CustomCollection.AvailableProduct model: model
