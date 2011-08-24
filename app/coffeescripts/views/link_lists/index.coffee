App.Views.LinkList.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #new-menu a": "add"

  initialize: ->
    @render()
    new App.Views.LinkList.New

  render: ->
    @collection.each (model) -> new App.Views.LinkList.Show model: model

  add: ->
    $('#add-menu').show()
    false
