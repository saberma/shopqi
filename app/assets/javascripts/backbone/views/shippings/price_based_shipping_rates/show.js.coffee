App.Views.Shipping.PriceBasedShippingRates.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    @render()

  render: ->
    self = this
    template = Handlebars.compile $('#promotional-rate-item').html()
    attrs = _.clone @model.attributes
    attrs['max_order_subtotal'] = if @model.get('max_order_subtotal') then "- #{@model.get('max_order_subtotal')}" else "起"
    $(@el).html template attrs
    $('#promotional-rate').append @el
