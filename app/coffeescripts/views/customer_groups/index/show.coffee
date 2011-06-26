App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix' #data-filter

  initialize: ->
    self = this
    this.render()
    $(this.el).attr 'id', "customer_group_#{@model.id}"

  render: ->
    template = Handlebars.compile $('#customer-group-item').html()
    is_current_search = @model.id == 0
    attrs = _.clone @model.attributes
    attrs['filters'] = @model.filters()
    attrs['is_current_search'] = is_current_search
    attrs['is_group'] = @model.id > 0
    $(@el).html template attrs
    $(@el).hide() if is_current_search
    $('#customer-groups').append @el
