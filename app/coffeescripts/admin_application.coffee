App =
  Views:
    LinkList: {}
    Link: {}
    SmartCollection: {}
    CustomCollection: {}
  Controllers: {}
  Collections: {}
  init: ->

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
UpdateableSelectBox = (select_id, input_id, create_label) ->
  select_box = $("##{select_id}")
  input_field = $("##{input_id}")
  if select_box.children().size() > 0
    select_box.append('<option value="">--------</option>')
  else
    input_field.show()
  select_box.append("<option value='create_new'>#{create_label}...</option>")
  select_box.change ->
    if $(this).val() is 'create_new'
      input_field.show().val('')
    else
      input_field.hide().val($(this).val())



$(document).ready ->
  App.init()

  $('#indicator').ajaxStart ->
    $(this).show()
    $(document).mousemove (e) ->
      $('#indicator').css('top', "#{e.pageY + 5}px").css('left', "#{e.pageX + 8}px")
  $('#indicator').ajaxStop ->
    $(this).hide()
    $(document).unbind 'mousemove'

  #外观、设置
  NavigationDropdown 'theme-link': '\u5916\u89C2', 'preferences-link': '\u8BBE\u7F6E'

  #下拉框
  UpdateableSelectBox 'product-type-select', 'product_product_type', '\u65B0\u589E\u7C7B\u578B' #新增类型
  UpdateableSelectBox 'product-vendor-select', 'product_vendor', '\u65B0\u589E\u5382\u5546' #新增厂商
