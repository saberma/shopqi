App.Views.LinkList.Index = Backbone.View.extend
  initialize: ->
    this.render()

  render: ->
    _(this.collection.models).each (model) ->
      new App.Views.LinkList.Show model: model
