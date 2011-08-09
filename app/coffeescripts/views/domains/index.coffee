App.Views.Domain.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #add-domain-link td": "add"
    "click .cancel": "cancel"
    "submit form": "save"

  initialize: ->
    self = this
    this.render()
    @collection.bind 'add', (model, collection) ->
      new App.Views.Domain.Show model: model, collection: collection
      self.cancel()

  render: ->
    self = this
    @collection.each (model) -> new App.Views.Domain.Show model: model, collection: self.collection

  save: ->
    host = $('#domain_host').val()
    if host
      $('.group-actions .btn').attr 'disabled', true
      @collection.create host: host, primary: false # 默认一定要为非主域名
    else
      $('#errorExplanation').show()
    false

  add: ->
    $('.group-actions .btn').attr 'disabled', false
    $('#errorExplanation').hide()
    $('#add-domain-link').hide()
    $('#add-domain').show()
    $('#domain_host').focus()
    false

  cancel: ->
    $('#add-domain').hide()
    $('#add-domain-link').show()
    $('#domain_host').val ''
    false
