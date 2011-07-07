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
      Index:
        Filter: {}
      Show:
        Order: {}
      New: {}
    CustomerGroup:
      Index: {}
    Asset:
      Index: {}
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

#日期
DateUtils =
  to_s: (date, format='yyyy-mm-dd hh:MM:ss') ->
    date = new Date(date)
    text = format.replace /yyyy/, date.getFullYear()
    text = text.replace /mm/, this.prefix(date.getMonth() + 1)
    text = text.replace /dd/, this.prefix(date.getDate())
    text = text.replace /hh/, this.prefix(date.getHours())
    text = text.replace /MM/, this.prefix(date.getMinutes())
    text.replace /ss/, this.prefix(date.getSeconds())

  formatDate: (date) ->
    this.to_s date, 'yyyy-mm-dd'

  prefix: (text) ->
    if "#{text}".length == 1 then "0#{text}" else text

#字符串
StringUtils =
  #转化为数组
  to_a: (text) ->
    _.uniq _.compact text.split(/[,\uFF0C]\s*/)

  endsWith: (str, ends) ->
    str.length >= ends.length and str.substring(str.length - ends.length) is ends

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

#标签
TagUtils =
  init: (tags_text_id = 'tags_text', tag_list_id = 'tag-list')->
    tag_items = $("##{tag_list_id} a")
    text_field = $("##{tags_text_id}")
    tag_items.click ->
      $(this).toggleClass('active')
      tags = StringUtils.to_a(text_field.val())
      tag = $(this).text()
      if tag not in tags
        tags.push tag
      else
        tags = _.without tags, tag
      text_field.val(tags.join(', '))
      false
    text_field.keyup ->
      tags = StringUtils.to_a(text_field.val())
      tag_items.each ->
        if $(this).text() in tags
          $(this).addClass('active')
        else
          $(this).removeClass('active')
    .keyup()

#地区
RegionUtils =
  init: (seed = [], region = '.region') ->
    $(region).each ->
      selects = $('select', this)
      selects.change ->
        $this = this
        select_index = selects.index($this) + 1
        select = selects.eq(select_index)
        if $(this).val() and select[0]
          $.get "/district/" + $(this).val(), (data) ->
            result = eval(data)
            options = select.attr("options")
            $("option:gt(0)", select).remove()
            $.each result, (i, item) -> options[options.length] = new Option(item[0], item[1])
            value = seed[select_index]
            select.val(value).change() if value # 级联回显

#为IE添加placeholder属性
setPlaceholderText = ->
  PLACEHOLDER_SUPPORTED = "placeholder" of document.createElement("input")
  return  if PLACEHOLDER_SUPPORTED or !$(":input[placeholder]").length
  $(":input[placeholder]").each ->
    add_placeholder = ->
      el.val(text).addClass "placeholder_text"  if !el.val() or el.val() == text
    el = $(this)
    text = el.attr("placeholder")
    add_placeholder()
    el.focus(->
      el.val("").removeClass "placeholder_text"  if el.val() == text
    ).blur ->
      el.val(text).addClass "placeholder_text"  unless el.val()

    el.closest("form").submit(->
      el.val ""  if el.val() == text
    ).bind "reset", ->
      setTimeout add_placeholder, 50
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

TogglePair = (ids) ->
  _.each ids, (id) ->
    $("##{id}").toggle()
  false

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

##### 注册handlebars helpers #####
#日期，用于订单列表创建日期的格式化
Handlebars.registerHelper 'date', (date, format)->
  format = null if format.hash
  DateUtils.to_s date, format

$(document).ready ->
  App.init()
  setPlaceholderText()

  window.moveIndicator = (e) -> $('#indicator').css('top', "#{e.pageY + 5}px").css('left', "#{e.pageX + 8}px")
  $(document).click moveIndicator
  $('#indicator').ajaxStart ->
    $(this).show()
    $(document).mousemove moveIndicator
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
