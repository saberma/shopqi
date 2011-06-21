App.Views.Order.Show.Note = Backbone.View.extend
  el: '#note-form'

  initialize: ->
    this.render()

  events:
    'click .cancel': 'cancel'
    'submit form': 'save'

  render: ->
    value = App.order.get('note')
    if value
      $('#note-body').text value
      $('#order_note').val value
      $('#order-note').show()

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
