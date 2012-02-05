App.Views.Payment.Alipay = Backbone.View.extend
  el: '#payment_alipay'

  events:
    'change .gateway-id'  : 'select'
    'click .payment_edit' : 'edit'     # 编辑
    'submit form'         : 'save'     # 保存
    "click .cancel"       : "cancel"   # 取消
    "click .destroy"      : "destroy"  # 删除

  initialize: ->
    @render()

  render: ->
    configed = @model.get('id')?
    @$('.activate_payment_provider strong').html "支付宝#{@model.get('service_name')}服务"
    @$('.payment_select').toggle !configed
    @$('.activate_payment_provider').toggle configed
    @$('.account_payment_provider').hide()

  select: -> # 显示表单
    selected = @$('.gateway-id').val() is '1'
    @edit() if selected
    @$('.account_payment_provider').toggle(selected)

  edit: -> # 编辑
    self = this
    template = Handlebars.compile $('#payment-alipay-form-item').html()
    @$('.payment-gateway-form').html template @model.attributes
    @$('.account_payment_provider form select').each -> $(this).val self.model.get($(this).attr('name')) # 显示下拉框
    @$('.account_payment_provider').show()
    @$('.activate_payment_provider').hide()
    false

  save: ->
    self = this
    @model.save {
        partner: self.$("input[name='partner']").val(),
        account: self.$("input[name='account']").val(),
        key: self.$("input[name='key']").val(),
        service: self.$("select[name='service']").val(),
        payment_type_id: 1,
      },
      success: (model, resp) ->
        msg '修改成功!'
        self.render()
    false

  cancel: ->
    @$('.account_payment_provider').hide()
    if @model.get('id')? # 编辑时
      @$('.activate_payment_provider').show()
      @$('.payment_select').hide()
    else # 新增时
      @$('.gateway-id').val 0
    false

  destroy: ->
    self = this
    if confirm '您确定要删除吗'
      @model.destroy
        success: (model, response) ->
          self.$('.payment_select').show()
          self.$('.account_payment_provider').hide()
          self.$('.activate_payment_provider').hide()
          msg '删除成功!'
          model.clear()
          model.id = null
    return false
