App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix' #data-filter

  initialize: ->
    self = this
    this.render()
    $(this.el).attr 'id', "customer_group_#{@model.id}"

  render: ->
    template = Handlebars.compile $('#customer-group-item').html()
    $(@el).html template @model.attributes
    $('#customergroup-current').after @el
