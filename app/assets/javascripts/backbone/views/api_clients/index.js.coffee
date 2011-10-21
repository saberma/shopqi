App.Views.ApiClient.Index = Backbone.View.extend
  el: '#main'

  events:
    'click #new-api a' : 'save'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()
    @collection.bind 'add', (model,collection) -> new App.Views.ApiClient.Show model: model, collection: self.collection

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.ApiClient.Show model: model

  save: ->
    @collection.create {},
      success: ->
        msg '新增成功！'
