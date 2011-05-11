App.Controllers.Products = Backbone.Controller.extend

  initialize: ->
    # 列表页面的查询条件：类型、厂商
    $('#vendor-filter-link').click ->
      $('#type-status-select > .filter-select').hide()
      $('#vendor-status-select > .filter-select').toggle()
      false

    $('#type-filter-link').click ->
      $('#vendor-status-select > .filter-select').hide()
      $('#type-status-select > .filter-select').toggle()
      false

    $(document).click ->
      $('#vendor-status-select > .filter-select').hide()
      $('#type-status-select > .filter-select').hide()

    ###### 新增页面 #####
    # 是否要求收货地址
    $('#variant_requires_shipping').change ->
      if $(this).attr('checked')
        $('#product_variants_attributes_0_weight').attr('disabled', false)
      else
        $('#product_variants_attributes_0_weight').attr('disabled', true).val('0.0')
    .change()

    # 是否跟踪库存
    $('#inventory-select').change ->
      if $(this).val() is ''
        $('#shopqi-inventory-new').hide()
        $('#inventory-policy-new').hide()
      else
        $('#shopqi-inventory-new').show()
        $('#inventory-policy-new').show()
    .change()

    # 显示商品选项
    new App.Views.ProductOption.Index collection: App.product_options

  routes:
    "edit":      ""
