App.Views.CustomerGroup.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'customer-group clearfix'

  events:
    "click #save_customer_group_link": 'show' # 显示保存表单
    "click .delete": 'destroy'
    "click .update.btn": 'update'

  initialize: ->
    self = this
    @model.previous_attributes = _.clone @model.attributes
    @model.bind 'change', -> self.change()
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

  change: ->
    this.render()
    # 已保存的分组可以更新
    equals = _.isEqual @model.previous_attributes, @model.attributes
    this.$('.update.btn').toggle(!equals) if @model.id > 0

  show: ->
    template = Handlebars.compile $('#new-customer-group-item').html()
    $.blockUI message: template()
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

  update: ->
    self = this
    @model.save null, success: (model, response) ->
      model.previous_attributes = _.clone model.attributes
      self.$('.update.btn').hide()
    false
