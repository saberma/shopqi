App.Views.Product.Show.Variant.Index = Backbone.View.extend

  el: '#variant-inventory'

  initialize: ->
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Product.Show.Variant.Show model: model
