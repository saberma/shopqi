App.Views.Order.Index.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .selector": 'select'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#show-order-item').html()
    attrs = @model.attributes
    attrs['financial_class'] = "o-#{@model.get('financial_status')}"
    attrs['fulfill_class'] = switch @model.get('fulfillment_status')
      when 'fulfilled' then 'o-fulfilled'
      when 'partial' then 'o-partial'
      when 'unshipped' then 'o-not-fulfilled'
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#order-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', this.$('.selector').attr('checked')
