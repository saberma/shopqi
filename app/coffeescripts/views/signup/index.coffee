App.Views.Signup.Index = Backbone.View.extend
  el: '#wrapper'

  #events:
    #"click #filter-bar a.price, #filter-bar a.color": "search"

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    new App.Views.Signup.Theme.Index collection: App.themes
