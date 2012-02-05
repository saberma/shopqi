App.Models.Payment = Backbone.Model.extend
  name: 'payment'
  url: ->
    if @id
      "/admin/payments/#{@id}"
    else
      "/admin/payments"

  validate: (attrs) ->
    errors = {}
    errors["方式"] = "不能为空." if attrs.name is ''
    if attrs.payment_type_id is 1 # 支付宝
      errors["合作者身份ID"] = "不能为空." if attrs.partner is ''
      errors["帐号"] = "不能为空." if attrs.account is ''
      errors["交易安全校验码"] = "不能为空." if !attrs.id? and attrs.key is '' # 新增时才校验

    if _(errors).size() is 0
      return
    else
      messages = _(errors).map (value, key) -> "#{key} #{value}"
      error_msg messages.join(' ')
      errors

  toJSON : ->
    @unset 'service_name', silent: true
    @unset 'id', silent: true
    attrs = this.wrappedAttributes()

App.Collections.Payments = Backbone.Collection.extend
  model: App.Models.Payment
  url: '/admin/payments'
