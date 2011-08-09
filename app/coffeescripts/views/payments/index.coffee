App.Views.Payment.Index = Backbone.View.extend
  el: '#main'
  events:
    'change #select_custom_payment_method' : 'select_method'
    'click #checkout' : 'change_checkout_config'


  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()
    $('#shop_customer_accounts_required').click ->
      $('#customer-accounts-required').show()
    $('#shop_customer_accounts_optional,#shop_customer_accounts_').each ->
      $(this).click ->
        $('#customer-accounts-required').hide()


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
