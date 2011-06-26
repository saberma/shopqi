App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix'

  events:
    "click #save_customer_group_link": 'show' # 显示保存表单
    "click .delete": 'destroy'

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

  show: ->
    template = Handlebars.compile $('#new-customer-group-item').html()
    $.blockUI message: template(), css: { width: '339px' }
    $('.blockOverlay,.shopify-dialog-title-close,.close-lightbox').attr('title','单击关闭').click($.unblockUI)
    false

  destroy: ->
    return false unless confirm '您确定要删除吗?'
    self = this
    collection = @model.collection
    @model.destroy
      success: (model, response) ->
        collection.remove self.model
        self.remove()
    false
