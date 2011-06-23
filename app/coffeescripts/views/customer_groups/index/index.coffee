App.Views.CustomerGroup.Index.Index = Backbone.View.extend
  el: '#customer-group-container'

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.CustomerGroup.Index.Show model: model
