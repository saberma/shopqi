App.Views.Order.Index.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .selector": 'select'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#show-order-item').html()
    $(@el).html template @model.attributes
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#order-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', this.$('.selector').attr('checked')
