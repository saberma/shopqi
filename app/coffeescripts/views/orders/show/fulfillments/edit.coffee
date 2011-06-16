App.Views.Order.Show.Fulfillment.Edit = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    $(@el).attr 'valign', 'bottom'
    this.render()

  render: ->
    template = Handlebars.compile $('#edit-fulfillment-item').html()
    $(@el).html template @options.line_item
    $('#mark-shipped table').append @el
