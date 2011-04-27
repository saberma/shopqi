App.Views.SmartCollection.Index = Backbone.View.extend
  initialize: ->
    this.render()

  render: ->
    _(this.collection.models).each (model) ->
      new App.Views.SmartCollection.Show model: model
