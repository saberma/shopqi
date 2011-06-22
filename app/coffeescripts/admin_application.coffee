App =
  Views:
    LinkList: {}
    Link: {}
    SmartCollection: {}
    CustomCollection: {}
    Order:
      Index: {}
      Show:
        Transaction: {}
        Fulfillment: {}
        LineItem: {}
        History: {}
    Customer:
      Index: {}
      Show: {}
    Product:
      Show:
        Variant: {}
      Index: {}
    ProductOption: {}
  Controllers:
    Orders: {}
    Customers: {}
  Collections: {}
  init: ->

##### 注册handlebars helpers #####
#日期，用于订单列表创建日期的格式化
Handlebars.registerHelper 'date', (date) ->
  date = new Date(date)
  "#{date.getFullYear()}-#{date.getMonth()}-#{date.getDate()} #{date.getHours()}:#{date.getSeconds()}"

#字符串
StringUtils =
  #转化为数组
  to_a: (text) ->
    _.uniq _.compact text.split(/[,\uFF0C]\s*/)

#表单
FormUtils =
  #表单输入项转化为hash: option1 => value
  to_h: (form) ->
    inputs = {}
    $(':input', form).each ->
      #product_variant[option1] => option1
      name = $(this).attr('name')
      match = name.match(/.+\[(.+)\]/)
      return true unless match
      # 单选项
      return true if $(this).attr('type') in ['radio', 'checkbox'] and !$(this).attr('checked')
      field = match[1]
      inputs[field] = $(this).val()
    inputs

#特效
Effect =
  scrollTo: (id) ->
    destination = $(id).offset().top
    $("html:not(:animated),body:not(:animated)").animate {
      scrollTop: destination-20
    }, 1000

#右上角菜单
NavigationDropdown = (navs) ->
  _.each navs, (label, parent_id) ->
    $("<a href='#' onclick='return false;' class='nav-link'>#{label}</a>").prependTo("##{parent_id}").click ->
      $(document).click()
      $(this).addClass('current').next().show()
      false
  $(document).click ->
    $('#secondary > li > a').removeClass 'current'
    $('#secondary > li > .nav-dropdown').hide()

#可新增下拉框
UpdateableSelectBox = (select_box, create_label) ->
  input_field = select_box.next()
  input_field = input_field.children('input') if input_field.hasClass('field_with_errors')
  if select_box.children().size() > 0
    select_box.append("<option value='' disabled='disabled'>--------</option>")
  else
    input_field.show()
  select_box.append("<option value='create_new'>#{create_label}...</option>")
  select_box.change ->
    if $(this).val() is 'create_new'
      input_field.show().val('')
    else
      input_field.hide().val($(this).val())
  #回显
  values = select_box.children().map -> this.value
  value = input_field.val()
  if value
    if value not in values
      select_box.val('create_new')
      input_field.show()
    else
      select_box.val(value)
  else if select_box.val() isnt 'create_new'
    input_field.val(select_box.val())


$(document).ready ->
  App.init()

  $('#indicator').ajaxStart ->
    $(this).show()
    $(document).mousemove (e) ->
      $('#indicator').css('top', "#{e.pageY + 5}px").css('left', "#{e.pageX + 8}px")
  $('#indicator').ajaxStop ->
    $(this).hide()
    $(document).unbind 'mousemove'

  $('#formatting').click ->
    $('#order-number-format-notes,#shop_order_number_format').each ->
      $(this).toggle()
    false
  $('#shop_order_number_format').keyup ->
    if $(this).val().match /{{number}}/
      val = $(this).val().replace /{{number}}/,1234
    else
      val = '#1234'
    $('#order-number-format-example').html val



  #外观、设置
  NavigationDropdown 'theme-link': '外观', 'preferences-link': '设置'

  #下拉框
  UpdateableSelectBox $('#product-type-select'), '新增类型'
  UpdateableSelectBox $('#product-vendor-select'), '新增厂商'
