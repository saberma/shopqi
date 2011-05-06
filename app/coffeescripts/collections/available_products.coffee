App.Collections.AvailableProducts = Backbone.Collection.extend
  model: Product
  url: '/admin/available_products'

  initialize: ->
