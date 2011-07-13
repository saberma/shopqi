App.Views.Theme.Index.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    self = this
    this.render()

  render: ->
    $('#themes').html ''
    @collection.each (model) ->
      new App.Views.Theme.Index.Show model: model
