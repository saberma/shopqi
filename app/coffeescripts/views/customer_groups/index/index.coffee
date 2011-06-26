App.Views.CustomerGroup.Index.Index = Backbone.View.extend
  el: '#customer-group-container'

  events:
    "click .customer-group": 'active'

  initialize: ->
    self = this
    this.render()

  render: ->
    # 默认分组:所有顾客、当前查询
    @collection.add [
      { id: -1, name: '所有顾客' },
      { id: 0 , name: '当前查询' }
    ]
    @collection.comparator = (model) -> model.id
    @collection.sort()
    @collection.each (model) -> new App.Views.CustomerGroup.Index.Show model: model
    this.$('.customer-group:first').addClass('active')

  active: (e) ->
    group = $(e.target).closest('.customer-group')
    return false if group.hasClass 'active' # 已激活
    this.$('.customer-group.active').removeClass('active')
    group_id = parseInt group.attr('id').substr('customer_group_'.length)
    group.addClass('active')
    customer_group = @collection.get(group_id)
    App.customer_group.set id: group_id, term: customer_group.get('term'), query: customer_group.get('query') #设置当前查询对象
