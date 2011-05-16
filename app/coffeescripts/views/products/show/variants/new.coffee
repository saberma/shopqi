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
    App.product_variants.create FormUtils.to_h this.$('form')
    false

  cancel: ->
    $('#new-variant-link').show()
    $('#new-variant').hide()
    false
