App.Views.Payment.Index = Backbone.View.extend
  el: '#main'
  events:
    'change #select_custom_payment_method' : 'select_method'
    'click #checkout' : 'change_checkout_config'
    'submit form#new_custom_payment' : 'save'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    @collection.bind 'add',(model) ->
      new App.Views.Payment.Show model: model
    this.render()

    $('#shop_customer_accounts_required').click ->
      $('#customer-accounts-required').show()
    $('#shop_customer_accounts_optional,#shop_customer_accounts_').each ->
      $(this).click ->
        $('#customer-accounts-required').hide()

    $('#alipay-gateway-id').change ->
      $('#account_payment_provider').toggle()
    $('#alipay_edit').click ->
      $('#account_payment_provider').toggle()
      $('#activate_payment_provider').hide()
    $('#cancel').click ->
      $('#account_payment_provider').toggle()
      $('#activate_payment_provider').toggle()
      $('#alipay-gateway-id option:eq(0)').attr 'selected', true

    $('#cancel_custom_payment_form').click ->
      $('#account_manual_payment_gateway').hide()
      $('#select_custom_payment_method option:eq(0)').attr 'selected', true

    if $('.field-with-errors input').size() > 0
      $('#account_payment_provider').show()
      $('#alipay-gateway-id option:eq(1)').attr 'selected', true

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Payment.Show model: model

  select_method: ->
    name = this.$('#select_custom_payment_method').val()
    if name == ""
      this.$('#account_manual_payment_gateway').hide()
    else if name == "create_new"
      this.$('#account_manual_payment_gateway').show()
      this.$('#payment_name').focus()
      this.$('#payment_name').select()
    else
      this.$('#account_manual_payment_gateway').show()
      this.$('#payment_name').val name
      this.$('#payment_name').focus()

  change_checkout_config: ->
    action = $('form#checkout-config').attr('action')
    attrs = $('form#checkout-config').serialize()
    $.post action, attrs, ->
      msg '修改成功！'

  save: ->
    $('form input#payment_submit').attr('disabled', true).val '正在保存...'
    self = this
    attrs =_.reduce this.$('form').serializeArray(), (result,obj) ->
      name = obj.name.replace(/payment\[|\]/g,"")
      result[name] = obj.value
      result
    ,{}
    @collection.create {
        name: attrs.name
        message: attrs.message
      },
      success: (model, resp) ->
        msg '新增成功！'
        $('form input#payment_submit').attr('disabled', false).val '保存'
        false
      error: (model,error)  ->
        error_msg error
        $('form input#payment_submit').attr('disabled', false).val '保存'
