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

    ###### 新增及查看页面 #####
    # 是否要求收货地址
    $('body').delegate "input.requires_shipping", 'change', ->
      container = $(this).parent().closest('table').parent().closest('table')
      requires_shipping_relate = $('.requires_shipping_relate', container)
      if $(this).attr('checked')
        requires_shipping_relate.attr('disabled', false)
      else
        requires_shipping_relate.attr('disabled', true).val('0.0')
    .change()

    # 是否跟踪库存
    $('body').delegate "select.inventory_management", 'change', ->
      container = $(this).parent().parent().parent()
      inventory_management_relate = $('.inventory_management_relate', container)
      if $(this).val() is ''
        inventory_management_relate.hide()
      else
        inventory_management_relate.show()
    .change()

    #标签
    $('#tag-list a').click ->
      $(this).toggleClass('active')
      tags = StringUtils.to_a($('#product_tags_text').val())
      tag = $(this).text()
      if tag not in tags
        tags.push tag
      else
        tags = _.without tags, tag
      $('#product_tags_text').val(tags.join(', '))
      false
    $('#product_tags_text').keyup ->
      tags = StringUtils.to_a($('#product_tags_text').val())
      $('#tag-list a').each ->
        if $(this).text() in tags
          $(this).addClass('active')
        else
          $(this).removeClass('active')
    .keyup()

  routes:
    "nothing":      "nothing"
