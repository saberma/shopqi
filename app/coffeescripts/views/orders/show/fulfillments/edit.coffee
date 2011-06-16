App.Views.Orders.Show.Fulfillments.Edit = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    $(@el).attr 'valign', 'bottom'
    this.render()

  render: ->
    template = Handlebars.compile $('#show-order-item').html()
    $(@el).html template @model.attributes
    $('#mark-shipped table').append @el
