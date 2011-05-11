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

    # 商品款式
    $('#enable-options').change ->
      if $(this).attr('checked')
        App.product_options.add new ProductOption()
        $('#create-options-frame').show()
      else
        App.product_options.each (model) ->
          App.product_options.remove model
        $('#create-options-frame').hide()
    .change()

  routes:
    "edit":      ""
