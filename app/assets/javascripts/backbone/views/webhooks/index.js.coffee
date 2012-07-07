App.Views.Webhook.Index = Backbone.View.extend
  el: '#webhooks'

  events:
    "click #add-webhook a": "add"

  initialize: ->
    @render()
    @showNote null, @collection
    @collection.bind 'add', @showNote
    @collection.bind 'remove', @showNote
    new App.Views.Webhook.New

  render: ->
    @collection.each (model) -> new App.Views.Webhook.Show model: model

  add: ->
    $('#add-webhook-details').show()
    $('#add-webhook').hide()
    false

  # private
  showNote: (model, collection) ->
    $('#webhook_body .note').toggle collection.isEmpty()
