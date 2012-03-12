App.Views.Shipping.Show = Backbone.View.extend
  tagName: 'table'
  className: 'shipping-rates-table data st ssb'

  events:
    "click .add-weight"             : "addWeight"
    "click .add-price"              : "addPrice"
    "click thead th .del"           : "destroy"

  initialize: ->
    @render()
    $('#custom-shipping').append @el
    $(@el).attr cellspacing: 0, cellspacing: 0

  render: ->
    self = this
    template = Handlebars.compile $('#shipping-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    new App.Views.Shipping.WeightBasedShippingRates.Index collection: @model.weight_based_shipping_rates, el: @$('.standard-rate')
    new App.Views.Shipping.PriceBasedShippingRates.Index collection: @model.price_based_shipping_rates, el: @$('.promotional-rate')
    new App.Views.Shipping.WeightBasedShippingRates.New collection: @model.weight_based_shipping_rates, el: @$('.new-standard-rate')
    new App.Views.Shipping.PriceBasedShippingRates.New collection: @model.price_based_shipping_rates, el: @$('.new-promotional-rate')

  addWeight: ->
    @$('.new-promotional-rate').hide()
    @$('.new-standard-rate').show()
    @$('.standard-rate-name-new').focus()
    false

  addPrice: ->
    @$('.new-standard-rate').hide()
    @$('.new-promotional-rate').show()
    @$('.promotional-rate-name-new').focus()
    false

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.shippings.remove self.model
          self.remove()
          msg '删除成功!'
    false
