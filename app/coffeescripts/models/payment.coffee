Payment = Backbone.Model.extend
  name: 'payment'

  validate: (attrs) ->
    if attrs.name == ""
      "方式不能为空"
