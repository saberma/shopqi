App.Views.Product.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeProductCheckbox'
    "change #product-select": 'changeProductSelect'
    "change #select-all": 'selectAll'
    "click label img": 'click_label_img' # 修正ie无法点击图片label选中复选框的问题

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()
    $.guide $('#add-prod a'), '点击此处增加一个商品', 'left' if @collection.length is 0
    $('#product-container').delegate '.variant-list-item', 'mouseover mouseout', (event) -> # 鼠标移至款式时，显示sku
      if event.type is 'mouseover'
        $('.variant-tip', this).show()
      else if event.type is 'mouseout'
        $('.variant-tip', this).hide()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Product.Index.Show model: model

  # 商品复选框全选操作
  selectAll: ->
    @$('.selector').attr 'checked', (@$('#select-all').attr('checked') is 'checked')
    @changeProductCheckbox()

  # 商品复选框操作
  changeProductCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked[0]
      #已选中款式总数
      this.$('#product-count').text "已选中 #{checked.size()} 个商品"
      $('#product-controls').show()
    else
      $('#product-controls').hide()

  # 操作面板修改
  changeProductSelect: ->
    operation = this.$('#product-select').val()
    is_destroy = (operation is 'destroy')
    if is_destroy and !confirm('您确定要删除选中的款式吗?')
      $('#product-select').val('')
      return false
    self = this
    checked_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/products/set", operation: operation, 'products[]': checked_ids, ->
      _(checked_ids).each (id) ->
        model = App.products.get id
        if is_destroy
          $('#product-controls').hide()
          App.products.remove model
        else if operation in ['publish', 'unpublish']
          model.set published: (operation is 'publish')
      msg_text = if is_destroy then '删除' else '更新'
      msg "批量#{msg_text}成功!"
    $('#product-select').val('')
    false

  click_label_img: (event) ->
    if $.browser.msie
      id = $(event.currentTarget).parent('label').attr('for')
      $("##{id}").click().change() if id?
