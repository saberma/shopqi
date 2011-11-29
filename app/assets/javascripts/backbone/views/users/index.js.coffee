App.Views.User.Index = Backbone.View.extend
  el: '#main'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.User.Show model: model , id: "user-" + model.id
      new App.Views.User.Permission model: model, id: "edit-user-permissions-" + model.id
