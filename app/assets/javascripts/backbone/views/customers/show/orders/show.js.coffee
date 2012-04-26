App.Views.Customer.Show.Order.Show = Backbone.View.extend
  tagName: 'tr'
  className: 'order'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#order-item').html()
    attrs = @model.attributes
    attrs['financial_class'] = @model.financial_class()
    attrs['fulfill_class'] = @model.fulfill_class()
    attrs['cancelled_class'] = 'abandoned' if @model.get('status') is 'cancelled'
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row #{cycle}"
    $('#order-table > tbody').append @el
