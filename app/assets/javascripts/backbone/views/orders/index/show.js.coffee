App.Views.Order.Index.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "change .selector": 'select'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#show-order-item').html()
    attrs = @model.attributes
    attrs['financial_class'] = @model.financial_class()
    attrs['fulfill_class'] = @model.fulfill_class()
    tips = _.map @model.get('line_items'), (line_item) ->
      name = if line_item.name? then line_item.name else '商品已被删除'
      "#{line_item.quantity} x #{name}"
    tips.push "#{@model.get('shipping_address')['info']}" if @model.get('shipping_address')?
    tips.push "配送方式:#{@model.get('shipping_name')}" if @model.get('shipping_name')?
    attrs['title'] = tips.join "<br/>"
    position = _.indexOf @model.collection.models, @model
    attrs['index'] = (position + 1)
    $(@el).html template attrs
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "visible row #{cycle}"
    $('#order-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', (@$('.selector').attr('checked') is 'checked')
