App.Views.Shipping.New = Backbone.View.extend
  el: '#new-region'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    @model = new App.Models.Shipping
    @collection = App.shippings
    @collection.bind 'add', (model, collection) ->
      self.cancel()
      msg '新增成功!'
      new App.Views.Shipping.Show model: model

  save: ->
    @collection.create title: this.$("#list_title").val()
    false

  cancel: ->
    $(@el).hide()
    false
