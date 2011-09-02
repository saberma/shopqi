App.Views.Customer.Index.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .selector": 'select'
    "click .contact-details": 'message'
    "click .display_message": 'nop'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#show-customer-item').html()
    attrs = @model.attributes
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#customer-table > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', this.$('.selector').attr('checked')

  message: ->
    this.$('.display_message').fadeIn('slow')
    false

  nop: -> #不向下传递事件
    false
