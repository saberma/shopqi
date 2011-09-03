App.Views.Order.Show.LineItem.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    $(@el).attr 'valign', 'bottom'
    this.render()

  render: ->
    template = Handlebars.compile $('#line-items-item').html()
    $(@el).html template @options.line_item
    $('#line-items').append @el
