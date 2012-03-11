App.Views.Shipping.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #add-region a" : "add"

  initialize: ->
    @render()
    new App.Views.Shipping.New

  render: ->
    @collection.each (model) -> new App.Views.Shipping.Show model: model

  add: ->
    $('#new-region').show()
    false
