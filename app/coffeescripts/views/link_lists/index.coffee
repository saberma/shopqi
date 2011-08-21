App.Views.LinkList.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    this.render()

  render: ->
    @collection.each (model) -> new App.Views.LinkList.Show model: model
