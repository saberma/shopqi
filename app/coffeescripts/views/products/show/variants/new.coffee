App.Views.Product.Show.Variant.New = Backbone.View.extend
  el: '#new-variant'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'save'
    this.render()

  render: ->
    $(@el).html $('#new-variant-item').html()

  save: ->
    self = this
    App.product_variants.create
      option1: this.$("input[name='product_variant[option1]']").val(),
      option2: this.$("input[name='product_variant[option2]']").val(),
      option3: this.$("input[name='product_variant[option3]']").val(),
      sku: this.$("input[name='product_variant[sku]']").val(),
      price: this.$("input[name='product_variant[price]']").val(),
      compare_at_price: this.$("input[name='product_variant[compare_at_price]']").val(),
      weight: this.$("input[name='product_variant[weight]']").val(),
      requires_shipping: this.$("input[name='product_variant[requires_shipping]']").val(),
      inventory_management: this.$("input[name='product_variant[inventory_management]']").val(),
      inventory_policy: this.$("input[name='product_variant[inventory_policy]']").val()
    false

  cancel: ->
    $('#new-variant-link').show()
    $('#new-variant').hide()
    false
