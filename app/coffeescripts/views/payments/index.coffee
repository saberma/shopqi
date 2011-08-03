App.Views.Payment.Index = Backbone.View.extend
  el: '#main'
  events:
    'change #select_custom_payment_method' : 'select_method'


  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

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

