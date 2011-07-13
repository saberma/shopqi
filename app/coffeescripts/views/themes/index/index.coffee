App.Views.Theme.Index.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    self = this
    this.render()

  render: ->
    @collection.each (model) ->
      new App.Views.Theme.Index.Show model: model
