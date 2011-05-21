App.Views.Product.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeProductCheckbox'
    "change #product-select": 'changeProductSelect'
    "click #select-all": 'selectAll'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Product.Index.Show model: model

  # 批量操作保存
  saveBatchForm: ->
    self = this
    checked_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    operation = this.$('#product-select').val()
    $.post "/admin/products/#{App.product.id}/set", operation: operation, 'products[]': checked_ids, ->
      _(checked_ids).each (id) ->
        model = App.products.get id
        if operation is 'destroy'
          $('#product-controls').hide()
          App.product.remove model
        else if operation in ['publish', 'hide']
          model.set published: (operation is 'publish')
      msg "批量#{operation is 'destroy' ? '删除' : '更新'}成功!"
      $('#product-select').val('')
    false

  # 商品复选框全选操作
  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')
    this.changeProductCheckbox()

  # 商品复选框操作
  changeProductCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked_variants[0]
      #已选中款式总数
      this.$('#product-count').text "已选中 #{checked_variants.size()} 个商品"
      $('#product-controls').show()
    else
      $('#product-controls').hide()

  # 操作面板修改
  changeProductSelect: ->
    value = this.$('#product-select').val()
    if value is 'destroy'
      if confirm('您确定要删除选中的款式吗?')
        this.saveBatchForm()
    $('#product-select').val('')
