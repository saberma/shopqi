App.Views.Webhook.New = Backbone.View.extend
  el: '#add-webhook-details'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    @model = new App.Models.Webhook
    @collection = App.webhooks
    @collection.bind 'add', (model, collection) ->
      self.cancel()
      msg '新增成功!'
      new App.Views.Webhook.Show model: model

  save: ->
    @collection.create event: @$("#webhook_event").val(), callback_url: @$("#webhook_callback_url").val()
    false

  cancel: ->
    $(@el).hide()
    $('#add-webhook').show()
    $('#webhook_event').val('').blur()
    false
