App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  className: 'customer-group clearfix' #data-filter

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#customer-group-item').html()
    $(@el).html template @model.attributes
    $('#customergroup-all').after @el
