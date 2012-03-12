App.Models.Shipping = Backbone.Model.extend
  name: 'shipping'

  initialize: (args) ->
    #backbone.rails的initialize被覆盖，导致无法获取id，需要手动调用
    @maybeUnwrap args
    @with_weights()
    @with_prices()

  toJSON : -> #重载，支持子实体
    attrs = @wrappedAttributes()
    if @weight_based_shipping_rates? #手动调用_clone，因为toJSON会加wraper
      weights_attrs = @weight_based_shipping_rates.models.map (model) -> _.clone model.attributes
      attrs['shipping']['weight_based_shipping_rates_attributes'] = weights_attrs
    if @price_based_shipping_rates? #手动调用_clone，因为toJSON会加wraper
      prices_attrs = @price_based_shipping_rates.models.map (model) -> _.clone model.attributes
      attrs['shipping']['price_based_shipping_rates_attributes'] = prices_attrs
    attrs

  with_weights: -> #设置weights关联
    if @collection? and @id?
      #@see http://documentcloud.github.com/backbone/#FAQ-nested
      @weight_based_shipping_rates = new App.Collections.WeightBasedShippingRates
      @weight_based_shipping_rates.url = "#{@collection.url}/#{@id}/weight_based_shipping_rates"
      @weight_based_shipping_rates.refresh @attributes.weight_based_shipping_rates
      @unset 'weight_based_shipping_rates', silent: true
    this

  with_prices: -> #设置prices关联
    if @collection? and @id?
      #@see http://documentcloud.github.com/backbone/#FAQ-nested
      @price_based_shipping_rates = new App.Collections.PriceBasedShippingRates
      @price_based_shipping_rates.url = "#{@collection.url}/#{@id}/price_based_shipping_rates"
      @price_based_shipping_rates.refresh @attributes.price_based_shipping_rates
      @unset 'price_based_shipping_rates', silent: true
    this

App.Collections.Shippings = Backbone.Collection.extend
  model: App.Models.Shipping
  url: '/admin/shippings'

App.Models.WeightBasedShippingRate = Backbone.Model.extend
  name: 'weight_based_shipping_rate'

App.Collections.WeightBasedShippingRates = Backbone.Collection.extend
  model: App.Models.WeightBasedShippingRate

App.Models.PriceBasedShippingRate = Backbone.Model.extend
  name: 'price_based_shipping_rate'

App.Collections.PriceBasedShippingRates = Backbone.Collection.extend
  model: App.Models.PriceBasedShippingRate
