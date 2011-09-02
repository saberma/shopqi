App.Views.ProductOption.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    @render()

  render: ->
    return unless $('#product-options-list')[0] #商品新增页面不需要Show
    position = _.indexOf @model.collection.models, @model
    attrs = _.clone @model.attributes
    attrs['position'] = position + 1
    attrs['options'] = App.product_variants.options()["option#{position+1}"]
    template = Handlebars.compile $('#show-option-item').html()
    $(@el).html template attrs
    $('#product-options-list').append @el
