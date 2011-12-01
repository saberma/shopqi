App.Views.Product.Index.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "change .selector": 'select'

  initialize: ->
    self = this
    @render()
    @model.bind 'change:published', (model) ->
      self.$('.status-hidden').toggle(!model.attributes.published)
    @model.bind 'remove', (model) -> self.remove()

  render: ->
    attrs = _.clone @model.attributes
    attrs.options = _.map @model.options.models, (model) -> model.attributes
    quantities = _(attrs.variants).map (variant) -> variant.inventory_quantity
    quantities = _(quantities).select (num) -> num
    attrs.quantity_sum = '&infin;'
    if quantities.length > 0
      attrs.quantity_sum = _.reduce quantities, (memo, num) ->
        memo + num
      , 0
    template = Handlebars.compile $('#show-product-item').html()
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row #{cycle}"
    $('#product-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', (@$('.selector').attr('checked') is 'checked')
