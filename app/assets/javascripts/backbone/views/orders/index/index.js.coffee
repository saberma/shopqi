App.Views.Order.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeOrderCheckbox'
    "change #order-select": 'changeOrderSelect'
    "change #select-all": 'selectAll'

  initialize: ->
    $('a.live-tipsy').tipsy live: true, html: true, gravity: 'sw' # 鼠标移到订单号时显示订单简要
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Order.Index.Show model: model

  # 商品复选框全选操作
  selectAll: ->
    @$('.selector').attr 'checked', (@$('#select-all').attr('checked') is 'checked')
    @changeOrderCheckbox()

  # 商品复选框操作
  changeOrderCheckbox: ->
    checked = @$('.selector:checked')
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
    checked_ids = _.map this.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/orders/set", operation: operation, 'orders[]': checked_ids, ->
      document.location.href = document.location.href
    false
