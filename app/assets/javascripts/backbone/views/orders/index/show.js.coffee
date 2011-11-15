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
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#order-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', (@$('.selector').attr('checked') is 'checked')
