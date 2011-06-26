App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix' #data-filter

  initialize: ->
    self = this
    @model.bind 'change', -> self.render()
    this.render()
    $(@el).attr 'id', "customer_group_#{@model.id}"
    $(@el).hide() if @model.id == 0
    $('#customer-groups').append @el

  render: ->
    template = Handlebars.compile $('#customer-group-item').html()
    attrs = _.clone @model.attributes
    attrs['filters'] = @model.filters()
    attrs['is_current_search'] = @model.id == 0
    attrs['is_group'] = @model.id > 0
    $(@el).html template attrs
