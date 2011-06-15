App.Views.Order.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeOrderCheckbox'
    "change #order-select": 'changeOrderSelect'
    "click #select-all": 'selectAll'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Order.Index.Show model: model

  # 商品复选框全选操作
  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')
    this.changeOrderCheckbox()

  # 商品复选框操作
  changeOrderCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked[0]
      #已选中款式总数
      this.$('#order-count').text "已选中 #{checked.size()} 个订单"
      $('#order-controls').show()
    else
      $('#order-controls').hide()

  # 操作面板修改
  changeOrderSelect: ->
    operation = this.$('#order-select').val()
    self = this
    checked_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/orders/set", operation: operation, 'orders[]': checked_ids, ->
      _(checked_ids).each (id) ->
        model = App.orders.get id
      msg "批量更新成功!"
    $('#order-select').val('')
    false
