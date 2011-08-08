App.Views.Domain.Index = Backbone.View.extend
  el: '#domains'

  #events:
  #  "submit #shop_new": "save"

  initialize: ->
    this.render()

  render: ->
    self = this
    @collection.each (model) -> new App.Views.Domain.Show model: model

  save: ->
    false
