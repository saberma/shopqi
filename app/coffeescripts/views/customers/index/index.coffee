App.Views.Customer.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeCustomerCheckbox'
    "change #customer-select": 'changeCustomerSelect'
    "click #select-all": 'selectAll'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Customer.Index.Show model: model

  # 商品复选框全选操作
  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')
    this.changeCustomerCheckbox()

  # 商品复选框操作
  changeCustomerCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked[0]
      #已选中款式总数
      this.$('#customer-count').text "已选中 #{checked.size()} 个订单"
      $('#customer-controls').show()
    else
      $('#customer-controls').hide()

  # 操作面板修改
  changeCustomerSelect: ->
    operation = this.$('#customer-select').val()
    checked_ids = _.map this.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/customers/set", operation: operation, 'customers[]': checked_ids, ->
      document.location.href = document.location.href
    false
