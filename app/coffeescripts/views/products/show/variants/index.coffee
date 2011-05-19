App.Views.Product.Show.Variant.Index = Backbone.View.extend

  el: '#variant-inventory'

  events:
    "change #product-select": 'changeProductSelect'
    "click #new-value .cancel": 'cancelUpdate'
    "submit form#batch-form": "saveBatchForm"

  # 批量操作保存
  saveBatchForm: ->
    self = this
    checked_variant_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    operation = this.$('#product-select').val()
    new_value = this.$("#new-value input[name='new_value']").val()
    $.post "/admin/products/#{App.product.id}/variants/set", operation: operation, new_value: new_value, 'variants[]': checked_variant_ids, ->
      _(checked_variant_ids).each (id) ->
        model = App.product_variants.get id
        attr = {}
        attr[operation] = new_value
        model.set attr
      msg '批量更新成功!'
      self.cancelUpdate()
    false

  # 操作面板修改
  changeProductSelect: ->
    if this.$('#product-select').val() in ['price', 'inventory_quantity', 'duplicate-1', 'duplicate-2', 'duplicate-3']
      this.$('#new-value').show()
      this.$("#new-value input[name='new_value']").focus()
    else
      this.$('#new-value').hide()

  # 取消操作面板修改
  cancelUpdate: ->
    this.$('#product-select').val('')
    this.$('#new-value').hide()
    this.$("#new-value input[name='new_value']").val('')
    false

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()
    # 款式复选框操作
    $(@el).delegate ".selector", 'change', ->
      checked_variants = self.$('.selector:checked')
      if checked_variants[0]
        #全选，则不能删除
        if checked_variants.size() == self.$('.selector').size()
          self.$("#product-select option[value='destroy']").attr('disabled', true)
        else
          self.$("#product-select option[value='destroy']").attr('disabled', false)
        #已选中款式总数
        self.$('#product-count').text "已选中 #{checked_variants.size()} 个款式"
        $('#product-controls').show()
      else
        $('#product-controls').hide()

  render: ->
    $('#variants-list').html('')
    #操作区域
    $('#product-select').html $('#product-select-item').tmpl()
    $('#row-head').html $('#row-head-item').tmpl()
    _(@collection.models).each (model) ->
      new App.Views.Product.Show.Variant.Show model: model
