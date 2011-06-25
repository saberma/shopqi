App.Views.CustomerGroup.Index.Index = Backbone.View.extend
  el: '#customer-group-container'

  events:
    "click .customer-group": 'active'

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    @collection.each (model) ->
      new App.Views.CustomerGroup.Index.Show model: model

  active: (e) ->
    group = $(e.target).closest('.customer-group')
    return false if group.hasClass 'active' # 已激活
    this.$('.customer-group.active').removeClass('active')
    group_id = parseInt group.attr('id').substr('customer_group_'.length)
    group.addClass('active')
    if group_id
      customer_group = @collection.get(group_id)
      App.customer_group.set id: group_id, term: customer_group.get('term'), query: customer_group.get('query') #设置当前查询对象
    else
      App.customer_group.set id: 0, term: '', query: '' #所有顾客(id=0)
