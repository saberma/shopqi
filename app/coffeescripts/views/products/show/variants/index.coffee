App.Views.Product.Show.Variant.Index = Backbone.View.extend

  el: '#variant-inventory'

  events:
    "change .selector": 'changeProductCheckbox'
    "change #product-select": 'changeProductSelect'
    "click #select-all": 'selectAll'
    "click #new-value .cancel": 'cancelUpdate'
    "submit form#batch-form": "saveBatchForm"

  # 批量操作保存
  saveBatchForm: ->
    self = this
    checked_variant_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    operation = this.$('#product-select').val()
    new_value = this.$("#new-value input[name='new_value']").val()
    # 复制
    if operation in ['duplicate-1', 'duplicate-2', 'duplicate-3']
      model = App.product_variants.get checked_variant_ids[0]
      attrs = model.attributes
      attrs['id'] = null
      index = operation.match(/duplicate-(\d)/)[1]
      attrs["option#{index}"] = new_value
      App.product_variants.create attrs
      this.$('#product-select').val('').change()
    else
      $.post "/admin/products/#{App.product.id}/variants/set", operation: operation, new_value: new_value, 'variants[]': checked_variant_ids, ->
        _(checked_variant_ids).each (id) ->
          model = App.product_variants.get id
          if operation is 'destroy'
            $('#product-controls').hide()
            App.product_variants.remove model
            msg '批量删除成功!'
          else
            attr = {}
            attr[operation] = new_value
            model.set attr
            msg '批量更新成功!'
        self.cancelUpdate()
    false

  # 款式复选框全选操作
  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')

  # 款式复选框操作
  changeProductCheckbox: ->
    checked_variants = this.$('.selector:checked')
    all_checked = (checked_variants.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked_variants[0]
      #全选，则不能删除
      this.$("#product-select option[value='destroy']").attr
        disabled: all_checked
      #单选，则可以复制
      this.$('#product-select').children('optgroup').children().attr
        disabled: (checked_variants.size() isnt 1)
      #已选中款式总数
      this.$('#product-count').text "已选中 #{checked_variants.size()} 个款式"
      $('#product-controls').show()
    else
      $('#product-controls').hide()
      this.$("#new-value input[name='new_value']").val('')

  # 操作面板修改
  changeProductSelect: ->
    value = this.$('#product-select').val()
    if value in ['price', 'inventory_quantity', 'duplicate-1', 'duplicate-2', 'duplicate-3']
      this.$('#new-value').show()
      this.$("#new-value input[name='new_value']").focus()
    else if value is 'destroy'
      if confirm('您确定要删除选中的款式吗?')
        this.saveBatchForm()
      else
        this.cancelUpdate()
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
    @collection.view = this
    _.bindAll this, 'render'
    this.render()
    # 删除集合内实体后要重新调整行class(odd, even)
    @collection.bind 'remove', (model, collection)->
      collection.each (model) ->
        index = _.indexOf collection.models, model
        cycle = if index % 2 == 0 then 'odd' else 'even'
        not_cycle = if index % 2 != 0 then 'odd' else 'even'
        model.view.$('.inventory-row').addClass(cycle).removeClass(not_cycle)

  render: ->
    new App.Views.Product.Show.Variant.QuickSelect collection: @collection
    $('#variants-list').html('')
    #操作区域
    $('#product-select').html $('#product-select-item').tmpl()
    $('#row-head').html $('#row-head-item').tmpl()
    _(@collection.models).each (model) ->
      new App.Views.Product.Show.Variant.Show model: model
