App.Views.Product.Show.Variant.New = Backbone.View.extend
  el: '#new-variant'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'save'
    variant = App.product_variants.last() # 获取最近的款式，用于设置默认值
    @model = new App.Models.ProductVariant price: variant.get('price'), compare_at_price: variant.get('compare_at_price'), weight: variant.get('weight')
    @model.bind 'error',(model, error) ->
      container = $('#errors_for_product_variant ul')
      container.html('')
      _(error).each (err, key) ->
        container.append "<li>#{key} #{err}</li>"
      $('#errors_for_product_variant').show()
    @render()

  render: ->
    template = Handlebars.compile $('#new-variant-item').html()
    attrs = _.clone @model.attributes
    attrs['options'] = App.product.options.models
    $(@el).html template attrs

  save: ->
    attrs = Utils.Form.to_h @$('form')
    if @model.set attrs
      App.product_variants.create attrs
    false

  cancel: ->
    $('#new-variant-link').show()
    $('#new-variant').hide()
    false
