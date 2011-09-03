App.Models.Payment = Backbone.Model.extend
  name: 'payment'

  validate: (attrs) ->
    if attrs.name == ""
      "方式不能为空"

App.Collections.Payments = Backbone.Collection.extend
  model: App.Models.Payment
  url: '/admin/payments'
