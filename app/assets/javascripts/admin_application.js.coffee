# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# 其中的jquery.MultiFile插件有改动:/images路径换为/assets
#
#=require jquery.min
#=require jquery_ujs
#=require jquery-ui-1.8.14.custom.min
#=require backbone_js
#=require plugins
#=require rails.validations
#=require jquery.blockUI
#=require jquery.miniColors
#=require jquery.MultiFile
#=require fileuploader
#=require plugins/jquery.guide
#=require plugins/jquery.blank_slate
#=require utils/utils
#=require_self
#=require backbone/admin

#字符串
@StringUtils =
  #转化为数组
  to_a: (text) ->
    _.uniq _.compact text.split(/[,\uFF0C]\s*/)

  startsWith: (str, starts) ->
    str.length >= starts.length and str.substring(0, starts.length) is starts

  endsWith: (str, ends) ->
    str.length >= ends.length and str.substring(str.length - ends.length) is ends

#为IE添加placeholder属性
@setPlaceholderText = ->
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

#右上角菜单
@NavigationDropdown = (navs) ->
  _.each navs, (label, parent_id) ->
    $("<a href='#' onclick='return false;' class='nav-link'>#{label}</a>").prependTo("##{parent_id}").click ->
      $(document).click()
      $(this).addClass('current').next().show()
      false
  $(document).click ->
    $('#secondary > li > a').removeClass 'current'
    $('#secondary > li > .nav-dropdown').hide()

@TogglePair = (ids) ->
  _.each ids, (id) ->
    $("##{id}").toggle()
  false

#可新增下拉框
@UpdateableSelectBox = (select_box, create_label) ->
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
@Handlebars.registerHelper 'date', (date, format)->
  format = null if format.hash
  Utils.Date.to_s date, format

#迭代，加入 index, index_plus 属性值
@Handlebars.registerHelper 'each_with_index', (context, block) ->
  _(context).map (item, index) ->
    attr = item: item, index: index, index_plus: (index + 1)
    block(attr)
  .join('')

$.fn.center = -> # 弹出窗口居中处理
  this.css("position","absolute")
  this.css("top", ( $(window).height() - this.height() ) / 2+$(window).scrollTop() + "px")
  this.css("left", ( $(window).width() - this.width() ) / 2+$(window).scrollLeft() + "px")
  this
$.blockUI.defaults.css.width = 'auto'
$.blockUI.defaults.onBlock = -> $('.blockUI.blockMsg').center()

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
  # [一般设置]-[币种]
  $('#currentcy_format').click ->
    $('#money_format_content').toggle()
    false
  $('#general-settings .has_example').keyup ->
    value = $(this).val() || '29.95'
    value = value.replace /{{amount}}/, '29.95'
    value = value.replace /{{amount_no_decimals}}/, '30'
    $(this).next('.note').html value

  $('#q').autocomplete({
    source: '/admin/lookup/query',
    minLength: 2,
    select: (event,ui) ->
      window.location = ui.item.url
  }).data("autocomplete")._renderItem = (ul,item) ->
    $("<li></li>")
    .data("item.autocomplete",item)
    .append("<a>"+item.title+"<br>"+item.kind+"</a>")
    .appendTo(ul)

  #外观、设置
  NavigationDropdown 'apps-link': '应用', 'theme-link': '外观', 'preferences-link': '设置'

  #下拉框
  UpdateableSelectBox $('#product-type-select'), '新增类型'
  UpdateableSelectBox $('#product-vendor-select'), '新增厂商'
  UpdateableSelectBox $('#select_custom_payment_method'), '新增普通付款方式'

  $('.blockOverlay,.shopqi-dialog-title-close,.close-lightbox').live 'click', -> $.unblockUI() # 关闭弹出窗口
