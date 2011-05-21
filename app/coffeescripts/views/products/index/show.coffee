App.Views.Product.Index.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    this.render()

  render: ->
    attrs = _.clone @model.attributes
    attrs.options = _.map @model.options.models, (model) -> model.attributes
    quantities = _.map attrs.variants, (variant) -> variant.inventory_quantity
    attrs.quantity_sum = _.reduce quantities, (memo, num) ->
      memo + num
    , 0
    $(@el).html $('#show-product-item').tmpl attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#product-table > tbody').append @el
