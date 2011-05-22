App.Views.Product.Show.Variant.New = Backbone.View.extend
  el: '#new-variant'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'save'
    this.render()
    @model = new ProductVariant
    @model.bind 'error',(model, error) ->
      container = $('#errors_for_product_variant ul')
      container.html('')
      _(error).each (err, key) ->
        container.append "<li>#{key} #{err}</li>"
      $('#errors_for_product_variant').show()

  render: ->
    $(@el).html $('#new-variant-item').tmpl()

  save: ->
    attrs = FormUtils.to_h this.$('form')
    if @model.set attrs
      App.product_variants.create attrs
    false

  cancel: ->
    $('#new-variant-link').show()
    $('#new-variant').hide()
    false
