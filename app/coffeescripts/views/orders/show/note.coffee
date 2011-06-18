App.Views.Order.Show.Note = Backbone.View.extend
  el: '#main'

  initialize: ->
    this.render()

  events:
    'click #note': 'show'
    'click #note-form .cancel': 'cancel'
    'submit #note-form form': 'save'

  render: ->
    value = App.order.get('note')
    if value
      $('#note-body').text value
      $('#order_note').val value
      $('#order-note').show()


  show: ->
    $('#order-note').hide()
    $('#note-form').show()
    false

  save: ->
    self = this
    value = $('#order_note').val()
    attr = { order: { note: value }, _method: 'put' }
    $.post App.order.url(), attr, ->
      App.order.set note: value
      self.cancel()
    false

  cancel: ->
    $('#note-form').hide()
    this.render()
    false
