App.Views.Product.Show.Variant.Show = Backbone.View.extend
  tagName: 'li'

  events:
    "submit form": "save"
    "click .edit-btn": "edit"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    _.bindAll this, 'render', 'edit'
    $(@el).attr 'id', "variant_#{@model.id}"
    @render()
    $('#variants-list').append @el
    @model.view = this
    # 批量修改价格、库存量
    @model.bind 'change:price', (model, price)->
      self.$('.price-cell').text price
      $("#variant-#{model.id}-price").val price
    @model.bind 'change:inventory_quantity', (model, inventory_quantity)->
      self.$('.qty-cell').text inventory_quantity
      $("#variant-inventory-quantity-#{model.id}").val inventory_quantity
    # 修改款式选项值后要更新快捷选择区域
    _([1,2,3]).each (i) ->
      self.model.bind "change:option#{i}", (model, option)->
        new App.Views.Product.Show.Variant.QuickSelect collection: model.collection
        new App.Views.ProductOption.Index collection: App.product.options
    # 删除
    @model.bind 'remove', (model)->
      new App.Views.Product.Show.Variant.QuickSelect collection: App.product_variants
      new App.Views.ProductOption.Index collection: App.product.options
      self.remove()
    # 校验
    @model.bind 'error', (model, error)->
      log error
      errors = _(error).map (err, key) ->
        "#{key} #{err}"
      .join(' ')
      error_msg  "无法保存款式: #{errors}"

  save: ->
    self = this
    @model.save Utils.Form.to_h(@$('form')),
      success: (model, resp) ->
        self.render()
        msg '修改成功!'
        self.cancel()
      error: ->
        error_msg 'SKU超出使用限制，无法修改'
    false

  render: ->
    index = _.indexOf @model.collection.models, @model
    cycle = if index % 2 == 0 then 'odd' else 'even'
    template = Handlebars.compile $('#show-variant-item').html()
    attrs = _.clone @model.attributes
    attrs['options'] = App.product.options.models
    attrs['edit_td_size'] = App.product.options.length + 5
    attrs['edit_td_size_except_options'] = 5 - App.product.options.length
    attrs['is_single_variant'] = App.product.options.length is 1
    $(@el).html template attrs
    @$('.inventory-row').addClass cycle
    @$("input.requires_shipping").change()
    @$("select.inventory_management").val(@model.attributes.inventory_management).change()
    @$("input[name='product_variant[inventory_policy]'][value='#{@model.attributes.inventory_policy}']").attr('checked', true)

  edit: ->
    $('#row-head').css opacity: 0.5
    @$('.inventory-row').hide()
    @$('tr.row-edit-details').show()
    @$('tr.inventory_row').hide()
    false

  cancel: ->
    $('#row-head').removeAttr('style')
    @$('.inventory-row').show()
    @$('tr.row-edit-details').hide()
    @$('tr.inventory_row').show()
    false
