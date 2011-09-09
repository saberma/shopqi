App.Views.Order.Show.History.Fulfillment = Backbone.View.extend

  events:
    "keyup .tracking-number": "showCompany" #修改配送记录
    "submit form": "save"

  initialize: ->
    @options.body.hide()
    this.render()

  render: ->
    template = Handlebars.compile $('#order-history-fulfillment-item').html()
    $(@el).html template @options.order_fulfillment
    @options.body.after @el
    this.$('.tracking-number').keyup()

  save: ->
    self = this
    attrs = notify_customer: (@$("input[name='notify_customer']").attr('checked') is 'checked'), fulfillment: {
      tracking_number: this.$("input[name='tracking_number']").val(),
      tracking_company: this.$("select[name='tracking_company']").val()
      tracking_company: this.$("select[name='tracking_company']").val()
    }, _method: 'put'
    $.post "/admin/orders/#{App.order.id}/fulfillments/#{@options.order_fulfillment.id}", attrs, ->
      self.destroy()
    false

  showCompany: (e)->
    span = $(e.target).next('span')
    active = if $(e.target).val() then true else false
    $('select', span).attr 'disabled', !active
    span.toggle(active)

  destroy: ->
    @options.body.show()
    this.remove()
