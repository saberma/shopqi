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

    # 新增页面
    $('#variant_requires_shipping').change ->
      if $(this).attr('checked')
        $('#product_variants_attributes_0_weight').attr('disabled', false)
      else
        $('#product_variants_attributes_0_weight').attr('disabled', true).val('0.0')
    .change()

  routes:
    "edit":      ""
