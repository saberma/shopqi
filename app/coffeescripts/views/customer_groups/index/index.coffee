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
    this.$('.customer-group.active').removeClass('active')
    group = $(e.target).closest('.customer-group')
    group_id = parseInt group.attr('id').substr('customer_group_'.length)
    group.addClass('active')
    if group_id
      customer_group = @collection.get(group_id)
      App.customer_group.set term: customer_group.get('term'), query: customer_group.get('query') #设置当前查询对象
    else
      App.customer_group.set term: '', query: '' #所有顾客
