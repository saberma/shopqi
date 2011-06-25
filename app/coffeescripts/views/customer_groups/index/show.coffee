App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix' #data-filter

  initialize: ->
    self = this
    this.render()
    $(this.el).attr 'id', "customer_group_#{@model.id}"

  render: ->
    template = Handlebars.compile $('#customer-group-item').html()
    attrs = _.clone @model.attributes
    attrs['filters'] = @model.filters()
    $(@el).html template attrs
    $('#customergroup-current').after @el
