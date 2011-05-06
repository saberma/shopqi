App.Views.CustomCollection.AvailableProducts = Backbone.View.extend
  initialize: ->
    this.render()

  render: ->
    _(this.collection.models).each (model) ->
      new App.Views.CustomCollection.AvailableProduct model: model
